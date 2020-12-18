class AddSendAtToNotifications < ActiveRecord::Migration
  def change
    unless column_exists?(:notifications, :send_at)
      add_column :notifications, :send_at, :datetime
      add_index :notifications, :send_at
    end
  end
end
