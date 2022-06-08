class CreateCallfireLog < ActiveRecord::Migration
  def change
    create_table :callfire_logs do |t|
      t.json :data
      t.integer :status
      t.string :kind
      t.string :action
      t.timestamps
    end
  end
end
