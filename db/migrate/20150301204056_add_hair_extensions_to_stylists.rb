class AddHairExtensionsToStylists < ActiveRecord::Migration
  def change
    add_column :stylists, :hair_extensions, :boolean
  end
end
