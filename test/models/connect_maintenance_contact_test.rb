require 'test_helper'

class ConnectMaintenanceContactTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

# == Schema Information
#
# Table name: connect_maintenance_contacts
#
#  id                   :integer          not null, primary key
#  contact_admin        :string
#  contact_email        :string
#  contact_first_name   :string
#  contact_last_name    :string
#  contact_order        :integer
#  contact_phone_number :string
#  contact_preference   :integer
#  contact_type         :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  location_id          :integer
#
# Indexes
#
#  index_connect_maintenance_contacts_on_location_id  (location_id)
#
# Foreign Keys
#
#  fk_rails_...  (location_id => locations.id)
#
