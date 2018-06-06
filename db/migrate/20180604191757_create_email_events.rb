class CreateEmailEvents < ActiveRecord::Migration
  def change
    unless ActiveRecord::Base.connection.table_exists? :email_events
      create_table :email_events do |t|
        t.string :category
        t.string :email
        t.string :event
        t.string :ip
        t.string :response
        t.string :sg_event_id
        t.string :sg_message_id
        t.string :smtp_id
        t.datetime :timestamp

        t.timestamps
      end
    end
  end
end
