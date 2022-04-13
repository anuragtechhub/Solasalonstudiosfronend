class CreateRentManagerEvents < ActiveRecord::Migration
  def change
    create_table :rent_manager_events do |t|
      t.integer :status, null: false, default: 0
      t.string :status_message
      t.jsonb :body, null: false
      t.references :object, polymorphic: true, index: true

      t.timestamps null: false
    end
    add_index :rent_manager_events, :status
  end
end
