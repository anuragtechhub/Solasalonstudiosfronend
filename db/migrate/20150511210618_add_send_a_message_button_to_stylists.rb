class AddSendAMessageButtonToStylists < ActiveRecord::Migration
  def change
    add_column :stylists, :send_a_message_button, :boolean, :default => true
  end
end
