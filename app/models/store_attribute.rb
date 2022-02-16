class StoreAttribute < ApplicationRecord
  belongs_to :store

  def metadata
    JSON.parse(attr)
  end
end
