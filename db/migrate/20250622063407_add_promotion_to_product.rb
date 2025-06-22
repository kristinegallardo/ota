class AddPromotionToProduct < ActiveRecord::Migration[8.0]
  def change
    add_reference :products, :promotion, null: true, foreign_key: true
  end
end
