class AddEmailToBulkOrder < ActiveRecord::Migration
  def change
    add_column :bulk_orders, :user_email, :string
  end
end
