class Retailer < ApplicationRecord
    validates :name, presence: true
    validates :url, presence: true, uniqueness: true

    has_many :comments, as: :commentable
end
