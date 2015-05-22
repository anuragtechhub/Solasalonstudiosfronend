class RenameTextToDescription < ActiveRecord::Migration
  def change
    rename_column :msas, :text, :description
  end
end
