class AddCosmetologyLicenseDateToStylists < ActiveRecord::Migration
  def change
    add_column :stylists, :cosmetology_license_date, :date
  end
end
