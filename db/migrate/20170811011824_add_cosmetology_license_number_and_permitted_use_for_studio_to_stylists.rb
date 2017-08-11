class AddCosmetologyLicenseNumberAndPermittedUseForStudioToStylists < ActiveRecord::Migration
  def change
    add_column :stylists, :cosmetology_license_number, :string
    add_column :stylists, :permitted_use_for_studio, :string
  end
end
