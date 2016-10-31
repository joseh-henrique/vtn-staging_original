class CreateStrategicPartners < ActiveRecord::Migration
  def change
    create_table :strategic_partners do |t|
      t.string :company_name
      t.string :company_address
      t.string :primary_contact
      t.string :company_phone
      t.string :company_email
      t.string :payment_terms
      t.string :vendor_id

      t.timestamps null: false
    end
  end
end
