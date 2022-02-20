require 'json'

module OtherAttributesHelper

  def get_attributes(attrs)
    JSON.parse(attrs) unless attrs.nil?
  end

end