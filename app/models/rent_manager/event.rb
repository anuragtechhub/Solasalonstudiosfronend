# frozen_string_literal: true

class RentManager::Event < ActiveRecord::Base
  belongs_to :object, polymorphic: true

  enum status: { 'queued' => 0, 'processed' => 1, 'failed' => 2 }
  # TMP disable
  # after_commit :process, on: :create

  private

    def process
      if queued?
        ::RentManager::WebhookJob.perform_async(id)
      end
    end
end

# == Schema Information
#
# Table name: rent_manager_events
#
#  id             :integer          not null, primary key
#  body           :jsonb            not null
#  object_type    :string
#  status         :integer          default(0), not null
#  status_message :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  object_id      :integer
#
# Indexes
#
#  index_rent_manager_events_on_object_type_and_object_id  (object_type,object_id)
#  index_rent_manager_events_on_status                     (status)
#
