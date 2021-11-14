class AddTikTokUrlToStylists < ActiveRecord::Migration
  def change
    add_column :stylists, :tik_tok_url, :string
  end
end
