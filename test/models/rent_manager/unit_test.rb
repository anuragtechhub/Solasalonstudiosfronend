# frozen_string_literal: true

require 'test_helper'

class RentManager::UnitTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

# == Schema Information
#
# Table name: rent_manager_units
#
#  id              :integer          not null, primary key
#  comment         :string
#  name            :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  location_id     :integer          not null
#  rm_location_id  :bigint
#  rm_property_id  :bigint           not null
#  rm_unit_id      :bigint           not null
#  rm_unit_type_id :bigint           not null
#
# Indexes
#
#  index_rent_manager_units_on_location_id     (location_id)
#  index_rent_manager_units_on_rm_location_id  (rm_location_id)
#  index_rent_manager_units_on_rm_property_id  (rm_property_id)
#  index_rent_manager_units_on_rm_unit_id      (rm_unit_id)
#
# Foreign Keys
#
#  fk_rails_...  (location_id => locations.id)
#
