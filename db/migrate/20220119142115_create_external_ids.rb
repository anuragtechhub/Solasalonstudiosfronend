class CreateExternalIds < ActiveRecord::Migration
  def change
    create_table :external_ids do |t|
      t.references :objectable, polymorphic: true, null: false
      t.integer :kind, null: false
      t.string :name, null: false
      t.string :value, null: false

      t.timestamps null: false
    end

    add_index :external_ids, %i[objectable_id objectable_type kind name], unique: true, name: 'idx_objectable_kind_name'
  end
end
