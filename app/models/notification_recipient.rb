# frozen_string_literal: true

class NotificationRecipient < ActiveRecord::Base
  belongs_to :notification
  belongs_to :stylist
end

# == Schema Information
#
# Table name: notification_recipients
#
#  id              :integer          not null, primary key
#  created_at      :datetime
#  updated_at      :datetime
#  notification_id :integer
#  stylist_id      :integer
#
# Indexes
#
#  index_notification_recipients_on_notification_id  (notification_id)
#  index_notification_recipients_on_stylist_id       (stylist_id)
#
