class ChangeLimitsForNotifications < ActiveRecord::Migration
  def change
    change_column :notifications, :title, :string, limit: 65
    change_column :notifications, :notification_text, :string, limit: 235
  end
end
