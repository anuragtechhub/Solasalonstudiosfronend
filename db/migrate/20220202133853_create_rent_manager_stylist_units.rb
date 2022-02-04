class CreateRentManagerStylistUnits < ActiveRecord::Migration
  def change
    create_table :rent_manager_stylist_units do |t|
      t.references :stylist, index: true, foreign_key: true
      t.references :rent_manager_unit, index: true, foreign_key: true
      t.bigint :rm_lease_id
      t.datetime :move_in_at
      t.datetime :move_out_at

      t.timestamps null: false
    end
  end
end
