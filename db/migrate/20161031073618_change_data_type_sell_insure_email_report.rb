class ChangeDataTypeSellInsureEmailReport < ActiveRecord::Migration
  def change
    change_column :sell_insure_email_reports, :email_sent_at,  :string
  end
end
