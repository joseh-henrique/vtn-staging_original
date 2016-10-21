class CreateBulkOrders < ActiveRecord::Migration
  def change
    create_table :bulk_orders do |t|
      t.string :promo_code
      t.integer :selected_plan
      t.integer :credits_count
      t.integer :credits_remaining
      t.integer :discount

      t.timestamps null: false
    end
  end
end
