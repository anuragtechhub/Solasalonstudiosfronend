class AddElectronicLicenseAgreementToStylists < ActiveRecord::Migration
  def change
    add_column :stylists, :electronic_license_agreement, :boolean, :default => false
  end
end
