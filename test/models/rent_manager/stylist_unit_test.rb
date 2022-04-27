# frozen_string_literal: true

require 'test_helper'

class RentManager::StylistUnitTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

# == Schema Information
#
# Table name: rent_manager_stylist_units
#
#  id                   :integer          not null, primary key
#  move_in_at           :datetime
#  move_out_at          :datetime
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  rent_manager_unit_id :integer
#  rm_lease_id          :bigint
#  stylist_id           :integer
#
# Indexes
#
#  index_rent_manager_stylist_units_on_rent_manager_unit_id  (rent_manager_unit_id)
#  index_rent_manager_stylist_units_on_rm_lease_id           (rm_lease_id)
#  index_rent_manager_stylist_units_on_stylist_id            (stylist_id)
#
# Foreign Keys
#
#  fk_rails_...  (rent_manager_unit_id => rent_manager_units.id)
#  fk_rails_...  (stylist_id => stylists.id)
#
