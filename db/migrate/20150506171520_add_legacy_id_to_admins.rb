class AddLegacyIdToAdmins < ActiveRecord::Migration
  def change
    add_column :admins, :legacy_id, :string
  end
end
