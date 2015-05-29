class AddStylistsIndex < ActiveRecord::Migration
  def change
    add_index :stylists, :url_name
    add_index :stylists, :status
  end
end
