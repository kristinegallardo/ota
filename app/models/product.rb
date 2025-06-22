class Product < ApplicationRecord
  belongs_to :promotion, optional: true

  has_many :order_items
  has_many :orders, through: :order_items

  validates :code, uniqueness: true
end
