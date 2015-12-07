class RemovePasswordDigestFromStylists < ActiveRecord::Migration
  def change
    remove_column :stylists, :password_digest, :string
  end
end
