class CalculateOrderItems < ActiveInteraction::Base
  array :order_item_ids, default: []

  def execute
    summary_details = []

    total_quantity_per_product.each do |result|
      computed_price = compute_products_with_promotion(result[:product_id], result[:total_quantity_per_product]).to_f
      product = Product.find_by(id: result[:product_id])

      summary =
        {
          product_name: product.name,
          product_id: product.id,
          computed_price: computed_price,
          promotion_id: product.promotion.id,
          total_quantity: result[:total_quantity_per_product]
        }
      summary_details << summary
    end

    total_amount = { total_amount: summary_details.sum { |item| item[:computed_price].to_f }.round(2) }
    summary_details << total_amount
  end

  private

  def total_quantity_per_product
    items = []

    order_items = OrderItem.where(id: order_item_ids)
    order_items = order_items.group_by { |item| item.product.id }
    
    order_items.each do |product_id, values|
       result =
        {
          product_id: product_id,
          total_quantity_per_product: values.pluck(:quantity).sum
        }

      items << result
    end
    items
  end

  def compute_products_with_promotion(product_id, total_quantity)
    product = Product.find_by(id: product_id)
    product_price = product.price
    return total_price_without_promotions(product_price, total_quantity) unless product.promotion.present?
    promotion_quantity = product.promotion.quantity
    discounted_price = product.promotion.discounted_price
    case product.promotion.promotion_type
    when 'fixed'
      (product.price * total_quantity) - discounted_price
    when 'bundle'
      ((total_quantity / promotion_quantity) * product_price) + (( total_quantity % promotion_quantity) * product_price)
    when 'percentage'
      return total_quantity * product_price * discounted_price if total_quantity >= promotion_quantity
      total_price_without_promotions(product_price, total_quantity)
    when 'bulk'
      return total_quantity * discounted_price if total_quantity >= promotion_quantity
      total_price_without_promotions(product_price, total_quantity)
    else
      total_price_without_promotions(product_price, total_quantity)
    end
  end

  def total_price_without_promotions(product_price, total_quantity)
    total_quantity * product_price
  end
end