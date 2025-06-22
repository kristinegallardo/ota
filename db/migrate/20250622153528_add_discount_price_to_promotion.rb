class AddDiscountPriceToPromotion < ActiveRecord::Migration[8.0]
  def change
    add_column :promotions, :discounted_price, :decimal, :precision => 20, :scale => 10
  end
end
