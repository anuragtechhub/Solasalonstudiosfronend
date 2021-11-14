class AddTikTokUrlToUpdateMySolaWebsites < ActiveRecord::Migration
  def change
    add_column :update_my_sola_websites, :tik_tok_url, :string
  end
end
