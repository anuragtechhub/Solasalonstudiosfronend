class AddUrlToEmailEvents < ActiveRecord::Migration
  def change
    add_column :email_events, :url, :string
  end
end
