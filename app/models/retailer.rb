class Retailer < ApplicationRecord
    validates :name, presence: true
    validates :url, presence: true, uniqueness: true

    has_many :comments, as: :commentable
    accepts_nested_attributes_for :comments
end
