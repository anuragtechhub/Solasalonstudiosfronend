class VideoCategoryVideo < ActiveRecord::Base
  belongs_to :video
  belongs_to :video_category

  validates :video, uniqueness: { scope: :video_category }
end

# == Schema Information
#
# Table name: video_category_videos
#
#  id                :integer          not null, primary key
#  video_id          :integer
#  video_category_id :integer
#  created_at        :datetime
#  updated_at        :datetime
#
# Indexes
#
#  index_video_category_videos_on_video_category_id  (video_category_id)
#  index_video_category_videos_on_video_id           (video_id)
#
