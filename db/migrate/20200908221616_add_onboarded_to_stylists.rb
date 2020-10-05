class AddOnboardedToStylists < ActiveRecord::Migration
  def change
    add_column :stylists, :onboarded, :boolean, default: false, null: false
    add_column :admins, :onboarded, :boolean, default: false, null: false
  end
end
