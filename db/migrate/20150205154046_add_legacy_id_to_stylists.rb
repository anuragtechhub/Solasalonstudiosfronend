class AddLegacyIdToStylists < ActiveRecord::Migration
  def change
    add_column :stylists, :legacy_id, :string
  end
end
