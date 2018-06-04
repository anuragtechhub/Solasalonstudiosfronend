class AddUseragentToEmailEvents < ActiveRecord::Migration
  def change
    add_column :email_events, :useragent, :string
  end
end
