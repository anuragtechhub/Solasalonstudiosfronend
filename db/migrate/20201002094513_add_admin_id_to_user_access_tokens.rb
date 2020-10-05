class AddAdminIdToUserAccessTokens < ActiveRecord::Migration
  def change
    add_column :user_access_tokens, :admin_id, :integer
    add_index :user_access_tokens, :admin_id
  end
end
