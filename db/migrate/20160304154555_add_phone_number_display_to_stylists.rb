class AddPhoneNumberDisplayToStylists < ActiveRecord::Migration
  def change
    add_column :stylists, :phone_number_display, :boolean, :default => true
  end
end
