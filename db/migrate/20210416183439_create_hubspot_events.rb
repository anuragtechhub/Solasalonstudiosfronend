class CreateHubspotEvents < ActiveRecord::Migration
  def change
    return if table_exists?(:hubspot_events)
    create_table :hubspot_events do |t|
      t.string :kind
      t.datetime :fired_at
      t.json :data

      t.timestamps null: false
    end
  end
end
