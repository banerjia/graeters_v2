class Retailer < ApplicationRecord
    # Validations
    validates :name, presence: true
    validates :url, presence: true, uniqueness: true

    # Associations
    has_many :stores
    has_many :states, through: :stores
    has_many :comments, as: :commentable
    accepts_nested_attributes_for :comments

    # Scopes
    default_scope { where({active: true})}
end
