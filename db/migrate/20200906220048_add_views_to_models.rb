class AddViewsToModels < ActiveRecord::Migration
  disable_ddl_transaction!

  def change
    add_column :brands, :views, :integer, null: false, default: 0
    add_index :brands, :views, algorithm: :concurrently, order: 'desc nulls last'

    add_column :deals, :views, :integer, null: false, default: 0
    add_index :deals, :views, algorithm: :concurrently, order: 'desc nulls last'

    add_column :tools, :views, :integer, null: false, default: 0
    add_index :tools, :views, algorithm: :concurrently, order: 'desc nulls last'

    add_column :sola_classes, :views, :integer, null: false, default: 0
    add_index :sola_classes, :views, algorithm: :concurrently, order: 'desc nulls last'

    add_column :videos, :views, :integer, null: false, default: 0
    add_index :videos, :views, algorithm: :concurrently, order: 'desc nulls last'
  end
end