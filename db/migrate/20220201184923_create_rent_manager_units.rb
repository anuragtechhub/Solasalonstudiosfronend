class CreateRentManagerUnits < ActiveRecord::Migration
  def change
    create_table :rent_manager_units do |t|
      t.references :location, index: true, foreign_key: true, null: false
      t.bigint :rm_unit_id, null: false
      t.bigint :rm_property_id, null: false
      t.string :name, null: false
      t.string :comment
      t.bigint :rm_unit_type_id, null: false

      t.timestamps null: false
    end
  end
end
