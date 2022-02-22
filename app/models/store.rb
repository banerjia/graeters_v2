require 'net/http'
require 'json'
require 'uri'
require 'elasticsearch/model'

class Store < ApplicationRecord

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks


  Store.__elasticsearch__.client = Elasticsearch::Client.new(
    host: ENV.fetch("ES_ENDPOINT"),
    http: { scheme: 'https', user: ENV.fetch("ES_USER"), password: ENV.fetch("ES_PASSWD") },
    reload_connections: true,
    reload_on_failure: true
  )

  # Scopes
  default_scope {where({active: true})}

  # Associations
  belongs_to :retailer, counter_cache: true
  belongs_to :state

  has_many :comments, as: :commentable
  has_one :other_attribute, as: :attributable

  # Validations
  validates :name, :addr_ln_1, :city, :state_id, presence: true

  # Callbacks
  after_validation :set_lat_lng, on: [ :create, :update]
  after_create :set_retailer_last_updated

  # Class Methods

  # Created for use with OpenSearch
  def address
    state_code = nil

    return_value = self.addr_ln_1.strip.titlecase
    return_value += ', ' + self.addr_ln_2.strip.titlecase unless self.addr_ln_2.blank?
    return_value += ', ' + self.city.titlecase

    return_value += ', ' + self.state.state_code
    return_value += ' - ' + self.zip_code unless self.zip_code.blank?

    return return_value
  end

  def as_indexed_json(options={})
    return_value = {}

    store_name = self.name
    store_name += " - %s" % [self.other_attribute.properties["store_number"]] \
                      unless self.other_attribute.nil? || self.other_attribute.properties["store_number"].blank?

    return_value = {
      id: self.id,
      name: store_name,
      location: {lat: self.latitude, lon: self.longitude},
      address: self.address,
      state: self.state.state_code,
      retailer: {
        id: self.retailer.id,
        name: self.retailer.name,
        url: self.retailer.url
      }
    }
    return_value[:region] = self.other_attribute.properties["region"] \
                        unless self.other_attribute.nil? || self.other_attribute.properties["region"].blank?
  
    return_value.as_json
  end

  def self.import

    stores = Store.left_outer_joins(:other_attribute).joins(:retailer, :state).includes(:state, :retailer, :other_attribute)
    
    stores.find_in_batches do |batched_stores|      
      Store.__elasticsearch__.client.bulk({
        index: Store.__elasticsearch__.index_name,
        type: Store.__elasticsearch__.document_type,
        body: batched_stores.map{ |store| {index: {_id: store.id, data: store.as_indexed_json}}}
      })
    end

  end

  # Private Functions
  private
  def set_lat_lng

      # Ignore latitute and longitude values if 
      # they are already present. 
      # TO-DO: Limit this to :create only. During an :update lat/long may change
      # if the address has changed. 
      return unless self.latitude.nil? && self.longitude.nil?

      address = "%s, %s, %s" % [self.addr_ln_1, self.city, self.state[:state_code]]
      address = CGI.escape(address)

      gmaps_uri = URI('https://maps.googleapis.com/maps/api/geocode/json?address='+ address + '&key=' + ENV.fetch("GMAPS_API"))

      gmaps_resp_obj = Net::HTTP.get_response(gmaps_uri)

      gmaps_resp = JSON.parse(gmaps_resp_obj.body)

      gmaps_location = gmaps_resp['results'].first['geometry']['location']

      self.latitude, self.longitude = gmaps_location['lat'], gmaps_location['lng']
  end

  def set_retailer_last_updated
    self.retailer.latest_store_add_date = DateTime.now
    self.retailer.save
  end

end
