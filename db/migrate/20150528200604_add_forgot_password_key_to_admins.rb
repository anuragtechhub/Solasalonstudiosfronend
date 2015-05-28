class AddForgotPasswordKeyToAdmins < ActiveRecord::Migration
  def change
    add_column :admins, :forgot_password_key, :string
  end
end
