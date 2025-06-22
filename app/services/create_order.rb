class CreateOrder < ActiveInteraction::Base
  string :customer_name

  array :order_items do
    hash do
      integer :product_id
      integer :quantity
    end
  end

  set_callback :validate, :after, -> { validate_order_items }, if: -> { order_items.present? }

  def execute
    return errors.merge!(order.errors) unless order.save
    create_order_items unless order_items.nil?

    {
      success: true,
      data: {
        order: order,
        order_items: order.order_items,
        order_products: order.products
      }
    }
  end

  private
  
  def order
    @order ||= Order.new(
      customer_name: customer_name,
      reference_number: reference_number
    )
  end

  def create_order_items
    order_items.map do |order_item|
      order.order_items.create(product_id: order_item[:product_id], quantity: order_item[:quantity])
    end
  end

  def reference_number
    "OTA-#{SecureRandom.hex(16)}"
  end

  def validate_order_items
    order_items.map do |order_item|
      errors.add(:message, "missing product_id") if order_item[:product_id].blank?
      errors.add(:message, "missing quantity") if order_item[:quantity].blank?
    end
  end
end