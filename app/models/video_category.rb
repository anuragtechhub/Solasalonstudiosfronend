class VideoCategory < ActiveRecord::Base

  has_many :video_category_videos
  has_many :videos, :through => :video_category_videos

  validates :name, :presence => true, :uniqueness => true, :length => { :maximum => 30 }

  def to_param
    name.gsub(' ', '-')
  end

end

# == Schema Information
#
# Table name: video_categories
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  position   :integer
#  created_at :datetime
#  updated_at :datetime
#
