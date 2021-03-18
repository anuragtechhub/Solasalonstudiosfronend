require 'test_helper'

class NotificationRecipientTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
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
