class CreatePromotions < ActiveRecord::Migration[8.0]
  def change
    create_table :promotions do |t|
      t.references :product, null: false, foreign_key: true
      t.string :code
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
