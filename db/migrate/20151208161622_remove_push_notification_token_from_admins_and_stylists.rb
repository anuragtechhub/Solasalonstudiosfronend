class RemovePushNotificationTokenFromAdminsAndStylists < ActiveRecord::Migration
  def change
    remove_column :admins, :push_notification_token, :string
    remove_column :stylists, :push_notification_token, :string
  end
end
