class Store < ApplicationRecord
  belongs_to :retailer, counter_cache: true
  belongs_to :state

  has_many :comments, as: :commentable
end
