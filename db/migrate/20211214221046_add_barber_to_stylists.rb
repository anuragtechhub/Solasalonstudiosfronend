class AddBarberToStylists < ActiveRecord::Migration
  def change
    add_column :stylists, :barber, :boolean, default: false, null: false
    add_column :update_my_sola_websites, :barber, :boolean
  end
end
