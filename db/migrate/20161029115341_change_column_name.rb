class ChangeColumnName < ActiveRecord::Migration
  def change
    rename_column :partner_details, :vendor_id, :vendor_token
  end
end
