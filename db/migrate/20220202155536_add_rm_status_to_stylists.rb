class AddRmStatusToStylists < ActiveRecord::Migration
  def change
    add_column :stylists, :rm_status, :string
  end
end
