require 'net/http'
require 'json'
require 'uri'
require 'elasticsearch/model'

class Store < ApplicationRecord

  include ElasticsearchStores

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

  # Custom Instance Methods
  def address

    return_value = self.addr_ln_1.strip.titlecase
    return_value += ', ' + self.addr_ln_2.strip.titlecase unless self.addr_ln_2.blank?
    return_value += ', ' + self.city.titlecase

    return_value += ', ' + self.state.code
    return_value += ' - ' + self.zip_code unless self.zip_code.blank?

    return return_value
  end

  # Private Functions
  private
  
  # Function to compute lat/lng info from address
  # This function is called from the callbacks after a :create or :update operation
  def set_lat_lng

      # Ignore latitute and longitude values if 
      # they are already present. 
      
      # TO-DO: Limit this to :create only. During an :update lat/long may change
      # if the address has changed. 
      return unless (self.latitude.nil? && self.longitude.nil?)

      # Create an address string to send to Google Maps API and encode it for use
      # in URL querystring
      address = CGI.escape(self.address)

      # Construct Google Maps API call to get all metadata about the address
      gmaps_uri = URI('https://maps.googleapis.com/maps/api/geocode/json?address='+ address + '&key=' + ENV.fetch("GMAPS_API"))

      # Make the call
      gmaps_resp_obj = Net::HTTP.get_response(gmaps_uri)

      # TO-DO: Error handling in case API call fails

      # Parse the response
      gmaps_resp = JSON.parse(gmaps_resp_obj.body)

      # Extract lat/lng info from the response
      gmaps_location = gmaps_resp['results'].first['geometry']['location']

      self.latitude, self.longitude = gmaps_location['lat'], gmaps_location['lng']
  end


  # Function to set the last store update for the Retailer
  # This is called from callback after :create
  def set_retailer_last_updated
    self.retailer.latest_store_add_date = DateTime.now
    self.retailer.save!
  end

end
