class AddLocationIndex < ActiveRecord::Migration
  def change
    add_index :locations, :url_name
    add_index :locations, :state
    add_index :locations, :status
  end
end
