class ConnectMaintenanceContact < ActiveRecord::Base
  include PgSearch::Model
  pg_search_scope :search_maintanence_contact, against: [:contact_type, :contact_email, :contact_first_name],
  using: {
    tsearch: {
      prefix: true,
      any_word: true
    }
  }
  belongs_to :location
  enum contact_preference: [:sms, :email, :phone, :url]

  def as_json(_options = {})
    super(include: {location: {only: [:name, :id]}})
  end
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
#  request_routing_url  :string
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
