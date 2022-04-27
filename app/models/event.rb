# frozen_string_literal: true

class Event < ActiveRecord::Base
  belongs_to :brand
  belongs_to :deal
  belongs_to :tool
  belongs_to :sola_class
  belongs_to :video
  belongs_to :userable, polymorphic: true

  scope :last_month, lambda {
    where('events.created_at > ?', 1.month.ago)
  }

  def user_email
    return userable.email_address if userable&.methods&.include?(:email_address)
    return userable.email if userable&.methods&.include?(:email)
  end
end

# == Schema Information
#
# Table name: events
#
#  id            :integer          not null, primary key
#  category      :string(255)
#  action        :string(255)
#  source        :string(255)
#  brand_id      :integer
#  deal_id       :integer
#  tool_id       :integer
#  sola_class_id :integer
#  video_id      :integer
#  value         :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  platform      :string(255)
#  userable_id   :integer
#  userable_type :string(255)
#
# Indexes
#
#  index_events_on_brand_id       (brand_id)
#  index_events_on_deal_id        (deal_id)
#  index_events_on_sola_class_id  (sola_class_id)
#  index_events_on_tool_id        (tool_id)
#  index_events_on_userable_id    (userable_id)
#  index_events_on_userable_type  (userable_type)
#  index_events_on_video_id       (video_id)
#
