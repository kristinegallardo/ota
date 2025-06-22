class RemoveProductFromPromotion < ActiveRecord::Migration[8.0]
  def change
    remove_reference :promotions, :product, null: false, foreign_key: true
  end
end
