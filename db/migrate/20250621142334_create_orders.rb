class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.string :reference_number

      t.timestamps
    end
  end
end
