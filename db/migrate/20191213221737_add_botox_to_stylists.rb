class AddBotoxToStylists < ActiveRecord::Migration
  def change
    add_column :stylists, :botox, :boolean
  end
end
