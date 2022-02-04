class ChangeIndexInExternalIds < ActiveRecord::Migration
  def change
    remove_index :external_ids, name: 'idx_objectable_kind_name'
    add_index :external_ids, :kind
    add_index :external_ids, %i[objectable_id objectable_type rm_location_id kind name], unique: true, name: 'idx_objectable_kind_name'
  end
end
