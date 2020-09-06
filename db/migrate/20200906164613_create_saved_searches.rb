class CreateSavedSearches < ActiveRecord::Migration
  def change
    create_table :saved_searches do |t|
      t.references :sola_stylist, index: true, foreign_key: { to_table: :stylist }
      t.references :admin, index: true, foreign_key: { to_table: :admins }
      t.text :query, null: false

      t.timestamps
    end
    add_index :saved_searches, :query
  end
end
