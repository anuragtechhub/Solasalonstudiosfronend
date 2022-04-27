# frozen_string_literal: true

class VideoView < ActiveRecord::Base
  belongs_to :video
  belongs_to :userable, polymorphic: true

  def as_json(_options = {})
    super(methods: [:video])
  end
end

# == Schema Information
#
# Table name: video_views
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
#  index_video_views_on_userable_type_and_userable_id  (userable_type,userable_id)
#  index_video_views_on_video_id                       (video_id)
#
