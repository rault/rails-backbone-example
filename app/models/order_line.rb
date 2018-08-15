class OrderLine < ApplicationRecord
  belongs_to :order
  has_one :spatula
  has_one :shipping_location
end
