class CreateSellInsures < ActiveRecord::Migration
  def change
    create_table :sell_insures do |t|
      t.string :customer_name
      t.string :email
      t.string :phone
      t.string :message
      t.boolean :phone_only, default:false
      t.boolean :email_only, default:false
      t.boolean :phone_or_email, default:false
      t.integer :appraisal_id

      t.timestamps null: false
    end
  end
end
