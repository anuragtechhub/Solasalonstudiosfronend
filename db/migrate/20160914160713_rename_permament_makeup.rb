class RenamePermamentMakeup < ActiveRecord::Migration
  def change
    rename_column :update_my_sola_websites, :permament_makeup, :permanent_makeup
  end
end
