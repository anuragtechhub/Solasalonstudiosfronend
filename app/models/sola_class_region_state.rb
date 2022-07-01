# frozen_string_literal: true

class SolaClassRegionState < ActiveRecord::Base
  include PgSearch::Model
  pg_search_scope :search_by_state_region, against: [:state, :id],
  associated_against: {
    sola_class_region: [:name],
  },
  using: {
    tsearch: {
      prefix: true,
      any_word: true
    }
  }

  belongs_to :sola_class_region

  validates :sola_class_region, uniqueness: { scope: :state, message: 'is already mapped to this state' }

  def state_enum
    [
      %w[Alabama Alabama],
      %w[Alaska Alaska],
      %w[Arizona Arizona],
      %w[Arkansas Arkansas],
      %w[California California],
      %w[Colorado Colorado],
      %w[Connecticut Connecticut],
      %w[Delaware Delaware],
      ['District of Columbia', 'District of Columbia'],
      %w[Florida Florida],
      %w[Georgia Georgia],
      %w[Hawaii Hawaii],
      %w[Idaho Idaho],
      %w[Illinois Illinois],
      %w[Indiana Indiana],
      %w[Iowa Iowa],
      %w[Kansas Kansas],
      %w[Kentucky Kentucky],
      %w[Louisiana Louisiana],
      %w[Maine Maine],
      %w[Maryland Maryland],
      %w[Massachusetts Massachusetts],
      %w[Michigan Michigan],
      %w[Minnesota Minnesota],
      %w[Mississippi Mississippi],
      %w[Missouri Missouri],
      %w[Montana Montana],
      %w[Nebraska Nebraska],
      %w[Nevada Nevada],
      ['New Hampshire', 'New Hampshire'],
      ['New Jersey', 'New Jersey'],
      ['New Mexico', 'New Mexico'],
      ['New York', 'New York'],
      ['North Carolina', 'North Carolina'],
      ['North Dakota', 'North Dakota'],
      %w[Ohio Ohio],
      %w[Oklahoma Oklahoma],
      %w[Oregon Oregon],
      %w[Pennsylvania Pennsylvania],
      ['Rhode Island', 'Rhode Island'],
      ['South Carolina', 'South Carolina'],
      ['South Dakota', 'South Dakota'],
      %w[Tennessee Tennessee],
      %w[Texas Texas],
      %w[Utah Utah],
      %w[Vermont Vermont],
      %w[Virginia Virginia],
      %w[Washington Washington],
      ['West Virginia', 'West Virginia'],
      %w[Wisconsin Wisconsin],
      %w[Wyoming Wyoming]
    ]
  end

  def as_json(_options = {})
    super(methods: %i[sola_class_region_name])
  end

  def sola_class_region_name
    sola_class_region ? sola_class_region.name : ''
  end
end
# == Schema Information
#
# Table name: sola_class_region_states
#
#  id                   :integer          not null, primary key
#  sola_class_region_id :integer
#  state                :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#
# Indexes
#
#  index_sola_class_region_states_on_sola_class_region_id  (sola_class_region_id)
#
