# frozen_string_literal: true

class TagsVideo < ActiveRecord::Base
  belongs_to :tag
  belongs_to :video
end

# == Schema Information
#
# Table name: tags_videos
#
#  id         :integer          not null, primary key
#  tag_id     :integer
#  video_id   :integer
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_tags_videos_on_tag_id    (tag_id)
#  index_tags_videos_on_video_id  (video_id)
#
