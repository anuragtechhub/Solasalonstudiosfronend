class AddUseragentToEmailEvents < ActiveRecord::Migration
  def change
  	unless ActiveRecord::Base.connection.column_exists?('email_events', 'useragent')
    	add_column :email_events, :useragent, :string
  	end
  end
end
