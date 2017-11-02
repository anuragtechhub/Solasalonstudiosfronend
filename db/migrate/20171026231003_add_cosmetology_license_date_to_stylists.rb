class AddCosmetologyLicenseDateToStylists < ActiveRecord::Migration
  def change
    add_column :stylists, :cosmetology_license_date, :date unless ActiveRecord::Base.connection.index_exists?(:stylists, :cosmetology_license_date)
  end
end
