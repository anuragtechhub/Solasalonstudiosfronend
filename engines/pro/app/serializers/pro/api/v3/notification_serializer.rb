# frozen_string_literal: true

module Pro
  class Api::V3::NotificationSerializer < ApplicationSerializer
    attributes :id, :title, :notification_text
    attribute(:object_type) { object.content_object&.class&.name }
    attribute(:object_id) { object.content_object&.id }
  end
end

#  id                     :integer          not null, primary key
#  brand_id               :integer
#  deal_id                :integer
#  tool_id                :integer
#  sola_class_id          :integer
#  video_id               :integer
#  notification_text      :text
#  send_push_notification :boolean
#  created_at             :datetime
#  updated_at             :datetime
#  blog_id                :integer
#  date_sent              :datetime
#  send_at                :datetime
#  title                  :string(255)
