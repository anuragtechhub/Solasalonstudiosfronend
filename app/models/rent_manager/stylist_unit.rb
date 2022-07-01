# frozen_string_literal: true

class RentManager::StylistUnit < ActiveRecord::Base
  include PgSearch::Model
  pg_search_scope :search_by_id_and_name, against: [:id],
  associated_against: {
    stylist: [:name],
    rent_manager_unit: [:name]
  },
  using: {
    tsearch: {
      prefix: true,
      any_word: true
    }
  }

  belongs_to :stylist
  belongs_to :rent_manager_unit, class_name: 'RentManager::Unit'

  def as_json(_options = {})
    super(methods: %i[rent_manager_unit_name stylist_name])
  end

  def rent_manager_unit_name
    rent_manager_unit ? rent_manager_unit.name : ''
  end

  def stylist_name
    stylist ? stylist.name : ''
  end

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
