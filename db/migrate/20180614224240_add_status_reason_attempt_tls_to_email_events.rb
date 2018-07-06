class AddStatusReasonAttemptTlsToEmailEvents < ActiveRecord::Migration
  def change
  	unless ActiveRecord::Base.connection.column_exists?('email_events', 'status')
	    add_column :email_events, :status, :string
	    add_column :email_events, :reason, :string
	    add_column :email_events, :attempt, :string
	    add_column :email_events, :tls, :string
	  end
  end
end
