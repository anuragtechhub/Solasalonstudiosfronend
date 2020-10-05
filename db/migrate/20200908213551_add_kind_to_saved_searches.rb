class AddKindToSavedSearches < ActiveRecord::Migration
  def change
    add_index :blogs, :status

    add_column :saved_searches, :kind, :string

    add_index :saved_searches, :kind
  end
end
