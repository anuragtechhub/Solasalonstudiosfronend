class HubspotLog < ActiveRecord::Base
  enum status: %w[success error]

  belongs_to :object, polymorphic: true
  belongs_to :location
end

# == Schema Information
#
# Table name: hubspot_logs
#
#  id          :integer          not null, primary key
#  action      :string
#  data        :json
#  kind        :string
#  object_type :string
#  status      :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  location_id :integer
#  object_id   :integer
#
# Indexes
#
#  index_hubspot_logs_on_location_id                (location_id)
#  index_hubspot_logs_on_object_type_and_object_id  (object_type,object_id)
#
# Foreign Keys
#
#  fk_rails_...  (location_id => locations.id)
#
