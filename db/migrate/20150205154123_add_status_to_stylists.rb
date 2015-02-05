class AddStatusToStylists < ActiveRecord::Migration
  def change
    add_column :stylists, :status, :string
  end
end
