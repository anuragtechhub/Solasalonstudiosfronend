class AddPushNotificationTokenToStylists < ActiveRecord::Migration
  def change
    add_column :stylists, :push_notification_token, :string
  end
end
