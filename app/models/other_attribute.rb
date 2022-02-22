require 'json'

class OtherAttribute < ApplicationRecord
  belongs_to :attributable, polymorphic: true

  def properties
    JSON.parse(self.data)
  end
end
