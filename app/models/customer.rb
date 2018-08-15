class Customer < ApplicationRecord
  has_many :shipping_locations
  has_many :orders
end
