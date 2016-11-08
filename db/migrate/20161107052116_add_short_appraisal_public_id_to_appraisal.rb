class AddShortAppraisalPublicIdToAppraisal < ActiveRecord::Migration
  def change
    add_column :appraisals, :short_appraisal_public_id, :string
  end
end
