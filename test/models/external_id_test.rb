# frozen_string_literal: true

require 'test_helper'

class ExternalIdTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

# == Schema Information
#
# Table name: external_ids
#
#  id              :integer          not null, primary key
#  kind            :integer          not null
#  name            :string           not null
#  objectable_type :string           not null
#  value           :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  objectable_id   :integer          not null
#  rm_location_id  :bigint
#
# Indexes
#
#  idx_objectable_kind_name              (objectable_id,objectable_type,rm_location_id,kind,name) UNIQUE
#  index_external_ids_on_kind            (kind)
#  index_external_ids_on_rm_location_id  (rm_location_id)
#
