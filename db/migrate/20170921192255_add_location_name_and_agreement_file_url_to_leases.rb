class AddLocationNameAndAgreementFileUrlToLeases < ActiveRecord::Migration
  def change
    add_column :studios, :location_name, :string
    add_column :leases, :agreement_file_url, :string
  end
end
