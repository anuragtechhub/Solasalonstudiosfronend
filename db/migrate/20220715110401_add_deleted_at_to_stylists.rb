class AddDeletedAtToStylists < ActiveRecord::Migration
  def change
    add_column :stylists, :deleted_at, :datetime
    add_index :stylists, :deleted_at
    add_column :stylists, :is_deleted, :boolean, default: :false
  end
end
