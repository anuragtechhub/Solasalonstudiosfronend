class AddUrlToEmailEvents < ActiveRecord::Migration
  def change
  	unless ActiveRecord::Base.connection.column_exists?('email_events', 'url')
    	add_column :email_events, :url, :string
  	end
  end
end
