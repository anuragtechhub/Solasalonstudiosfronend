class RentManagerTenant < ActiveRecord::Base
end

# == Schema Information
#
# Table name: rent_manager_tenants
#
#  id                    :integer          not null, primary key
#  active_end_date       :datetime
#  active_start_date     :datetime
#  email                 :string
#  first_name            :string
#  last_name             :string
#  last_payment_date     :datetime
#  last_transaction_date :datetime
#  move_in_at            :datetime
#  move_out_at           :datetime
#  name                  :string
#  phone                 :string
#  status                :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  location_id           :integer
#  property_id           :integer
#  tenant_id             :integer
#
