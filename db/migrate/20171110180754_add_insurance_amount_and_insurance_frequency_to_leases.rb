class AddInsuranceAmountAndInsuranceFrequencyToLeases < ActiveRecord::Migration
  def change
    add_column :leases, :insurance_amount, :integer
    add_column :leases, :insurance_frequency, :string

    remove_column :leases, :sola_provided_insurance, :boolean, :default => false
    remove_column :leases, :sola_provided_insurance_frequency, :string    
  end
end
