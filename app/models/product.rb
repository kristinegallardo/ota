class Product < ApplicationRecord
  has_one :promotion
  has_many :order_items
  has_many :orders, through: :order_items
end
