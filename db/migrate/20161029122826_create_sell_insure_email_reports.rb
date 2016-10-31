class CreateSellInsureEmailReports < ActiveRecord::Migration
  def change
    create_table :sell_insure_email_reports do |t|
      t.integer :appraisal_id
      t.string :appraisal_name
      t.datetime :email_sent_at
      t.string :customer_id
      t.string :customer_name
      t.string :appraisal_link

      t.timestamps null: false
    end
  end
end
