class CreateNotificationRecipients < ActiveRecord::Migration
  def change
    create_table :notification_recipients do |t|
      t.references :notification, index: true
      t.references :stylist, index: true

      t.timestamps
    end
  end
end
