class CreateSalesReceipts < ActiveRecord::Migration
  def change
    create_table :sales_receipts do |t|
      t.integer :receipt_id, :null => false, :default => 0
      t.integer :customer_id
      t.datetime :email_sent_at

      t.timestamps null: false
    end
  end
end
