class AddPushNotificationTokenToAdmins < ActiveRecord::Migration
  def change
    add_column :admins, :push_notification_token, :string
  end
end
