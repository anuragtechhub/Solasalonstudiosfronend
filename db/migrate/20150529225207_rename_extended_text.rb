class RenameExtendedText < ActiveRecord::Migration
  def change
    rename_column :articles, :extended_text, :article_url
  end
end
