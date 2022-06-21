class AddRequestRoutingUrlToConnectMaintenanceContacts < ActiveRecord::Migration
  def change
    add_column :connect_maintenance_contacts, :request_routing_url, :string
  end
end
