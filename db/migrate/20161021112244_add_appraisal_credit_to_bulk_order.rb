class AddAppraisalCreditToBulkOrder < ActiveRecord::Migration
  def change
    add_column :bulk_orders, :appraisal_credits, :string
  end
end
