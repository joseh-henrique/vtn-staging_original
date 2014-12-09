class CreateSharecounts < ActiveRecord::Migration
  def change
    create_table :sharecounts do |t|
      t.references :appraisal
      t.references :user
      t.string :network

      t.timestamps
    end
    add_index :sharecounts, :appraisal_id
    add_index :sharecounts, :user_id
  end
end
