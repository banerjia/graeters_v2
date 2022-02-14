require 'net/http'
require 'json'
require 'uri'

class Store < ApplicationRecord

  # Associations
  belongs_to :retailer, counter_cache: true
  belongs_to :state

  has_many :comments, as: :commentable

  # Validations
  validates :name, :addr_ln_1, :city, :state_id, presence: true

  # Callbacks
  after_validation :set_lat_lng, on: [ :create, :update]
  after_create :set_retailer_last_updated


  def full_address
    
  end

  # Private Functions
  private
  def set_lat_lng
      address = "%s, %s, %s" % [self.addr_ln_1, self.city, self.state.state_code]
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
