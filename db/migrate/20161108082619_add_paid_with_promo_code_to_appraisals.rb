class AddPaidWithPromoCodeToAppraisals < ActiveRecord::Migration
  def change
    add_column :appraisals, :paid_with_promo_code, :string
  end
end
