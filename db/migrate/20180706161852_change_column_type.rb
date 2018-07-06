class ChangeColumnType < ActiveRecord::Migration
  def change
  	change_column :email_events, :category, :text
  	change_column :email_events, :email, :text
  	change_column :email_events, :event, :text
  	change_column :email_events, :ip, :text
  	change_column :email_events, :response, :text
  	change_column :email_events, :sg_event_id, :text
  	change_column :email_events, :sg_message_id, :text
  	change_column :email_events, :smtp_id, :text
  	change_column :email_events, :timestamp, :text
  	change_column :email_events, :useragent, :text
  	change_column :email_events, :url, :text
  	change_column :email_events, :status, :text
  	change_column :email_events, :reason, :text
  	change_column :email_events, :attempt, :text
  	change_column :email_events, :tls, :text
  end
end
