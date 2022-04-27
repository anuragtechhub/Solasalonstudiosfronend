# frozen_string_literal: true

class HubspotEvent < ActiveRecord::Base
  validates :fired_at, :kind, :data, presence: true

  after_commit :process, on: :create

  private

    def process
      # ::Hubspot::EventProcessor.perform_async(self.id)
    end
end

# == Schema Information
#
# Table name: hubspot_events
#
#  id         :integer          not null, primary key
#  data       :json
#  fired_at   :datetime
#  kind       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
