class CreateStudios < ActiveRecord::Migration
  def change
    create_table :studios do |t|
      t.string :name
      t.string :rent_manager_id, index: true
      t.references :stylist, index: true

      t.timestamps
    end
  end
end
