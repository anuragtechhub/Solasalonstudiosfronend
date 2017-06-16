class AddMicrobladingToStylists < ActiveRecord::Migration
  def change
    add_column :stylists, :microblading, :boolean
  end
end
