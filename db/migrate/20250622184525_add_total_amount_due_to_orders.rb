class AddTotalAmountDueToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :total_amount_due, :decimal, :precision => 20, :scale => 10
  end
end
