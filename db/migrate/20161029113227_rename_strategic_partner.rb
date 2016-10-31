class RenameStrategicPartner < ActiveRecord::Migration
  def change
    def self.up
      rename_table :strategic_partners, :strategic_partner_details
    end
    def self.down
      rename_table :strategic_partner_details, :strategic_partners
    end
  end
end
