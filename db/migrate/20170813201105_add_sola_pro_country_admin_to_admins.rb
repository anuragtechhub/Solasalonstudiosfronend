class AddSolaProCountryAdminToAdmins < ActiveRecord::Migration
  def change
    add_column :admins, :sola_pro_country_admin, :string
  end
end
