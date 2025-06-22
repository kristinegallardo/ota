class Order < ApplicationRecord
  belongs_to :promotion, optional: true

  has_many :order_items, inverse_of: :order, dependent: :destroy
  has_many :products, through: :order_items

  accepts_nested_attributes_for :order_items, allow_destroy: true, reject_if: :all_blank
end
