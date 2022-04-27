# frozen_string_literal: true

class WatchLater < ActiveRecord::Base
  belongs_to :video
  belongs_to :user

  def as_json(_options = {})
    super(methods: [:video])
  end
end

# == Schema Information
#
# Table name: watch_laters
#
#  id            :integer          not null, primary key
#  video_id      :integer
#  created_at    :datetime
#  updated_at    :datetime
#  userable_type :string(255)
#  userable_id   :integer
#
# Indexes
#
#  index_watch_laters_on_userable_type_and_userable_id  (userable_type,userable_id)
#  index_watch_laters_on_video_id                       (video_id)
#
