class AddPromotionTypeToPromotion < ActiveRecord::Migration[8.0]
  def change
    add_column :promotions, :promotion_type, :string
  end
end
