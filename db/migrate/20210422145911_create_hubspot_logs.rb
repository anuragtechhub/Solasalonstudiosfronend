class CreateHubspotLogs < ActiveRecord::Migration
  def change
    return if table_exists?(:hubspot_logs)
    create_table :hubspot_logs do |t|
      t.json :data
      t.integer :status
      t.references :object, polymorphic: true, index: true
      t.references :location, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
