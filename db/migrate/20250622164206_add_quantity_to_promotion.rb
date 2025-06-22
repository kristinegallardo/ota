class AddQuantityToPromotion < ActiveRecord::Migration[8.0]
  def change
    add_column :promotions, :quantity, :integer
  end
end
