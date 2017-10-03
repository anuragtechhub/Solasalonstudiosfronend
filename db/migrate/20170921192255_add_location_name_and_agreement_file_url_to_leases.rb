class AddLocationNameAndAgreementFileUrlToLeases < ActiveRecord::Migration
  def change
    unless ActiveRecord::Base.connection.column_exists?(:studios, :location_name)
      add_column :studios, :location_name, :string
    end
    unless ActiveRecord::Base.connection.column_exists?(:leases, :agreement_file_url)
      add_column :leases, :agreement_file_url, :string 
    end
  end
end
