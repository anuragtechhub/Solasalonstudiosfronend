class AddDefaultValueForAcceptingNewClients < ActiveRecord::Migration
  def change
    change_column :stylists, :accepting_new_clients, :boolean, :default => true
  end
end
