# frozen_string_literal: true

# Ability to connect some models with external db tables
class ExternalId < ActiveRecord::Base
  include PgSearch::Model
  pg_search_scope :search_by_name_and_id, against: [:id, :name],
  using: {
    tsearch: {
      prefix: false
    }
  }
  belongs_to :objectable, polymorphic: true
  belongs_to :stylist, foreign_key: :objectable_id, foreign_type: 'Stylist'
  belongs_to :location, foreign_key: :objectable_id, foreign_type: 'Location'

  enum kind: {
    rent_manager: 0
  }

  validates :objectable_type, :objectable_id, :name, :kind, :value, presence: true
  validates :name, uniqueness: { scope: %i[objectable_id objectable_type kind rm_location_id] }
  validates :rm_location_id, presence: true, if: :rent_manager?

  scope :rent_manager, -> { where(kind: 'rent_manager') }
  scope :rent_manager_locations, -> { rent_manager.where(name: :property_id) }

  def self.find_location_by(rm_location_id, rm_property_id)
    rent_manager.find_by(
      rm_location_id:  rm_location_id,
      name:            'property_id',
      value:           rm_property_id,
      objectable_type: 'Location'
    )&.location
  end

  def as_json(_options = {})
      super(methods: %i[ objectable_name])
  end

  def objectable_name
      objectable ? objectable.name : ''
  end

  def self.find_stylist_by(rm_location_id, rm_tenant_id)
    rent_manager.find_by(
      rm_location_id:  rm_location_id,
      name:            'tenant_id',
      value:           rm_tenant_id,
      objectable_type: 'Stylist'
    )&.stylist
  end
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
