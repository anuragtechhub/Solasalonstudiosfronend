class AddStatusReasonAttemptTlsToEmailEvents < ActiveRecord::Migration
  def change
    add_column :email_events, :status, :string
    add_column :email_events, :reason, :string
    add_column :email_events, :attempt, :string
    add_column :email_events, :tls, :string
  end
end
