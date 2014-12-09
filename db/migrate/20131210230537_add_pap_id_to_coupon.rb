class AddPapIdToCoupon < ActiveRecord::Migration
  def change
    add_column :coupons, :pap_id, :string
  end
end
