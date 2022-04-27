# frozen_string_literal: true

class UserNotification < ActiveRecord::Base
  belongs_to :notification
  belongs_to :userable, polymorphic: true
  after_save :update_badge

  def details
    deets = {}

    if notification
      deets[:id] = notification.id
      deets[:content_object] = notification.content_object
      deets[:type] = deets[:content_object].class.name
    end

    deets
  end

  def as_json(_options = {})
    super(methods: [:details])
  end

  def update_badge
    return if dismiss_date.blank?

    ::Notifications::SendJob.perform_in(30.seconds, 'update_badge', nil, userable_id)
  end
end

# == Schema Information
#
# Table name: user_notifications
#
#  id              :integer          not null, primary key
#  userable_type   :string(255)
#  userable_id     :integer
#  dismiss_date    :datetime
#  notification_id :integer
#  created_at      :datetime
#  updated_at      :datetime
#
# Indexes
#
#  index_user_notifications_on_notification_id                (notification_id)
#  index_user_notifications_on_userable_type_and_userable_id  (userable_type,userable_id)
#
