class AddChatCodeToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :chat_code, :text
  end
end
