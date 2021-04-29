class AddKindToHubspotLogs < ActiveRecord::Migration
  def change
    return if column_exists?(:hubspot_logs, :kind)
    add_column :hubspot_logs, :kind, :string
    return if column_exists?(:hubspot_logs, :action)
    add_column :hubspot_logs, :action, :string
  end
end
