# frozen_string_literal: true

class VideoCountry < ActiveRecord::Base
  belongs_to :video
  belongs_to :country
end

# == Schema Information
#
# Table name: video_countries
#
#  id         :integer          not null, primary key
#  video_id   :integer
#  country_id :integer
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_video_countries_on_country_id  (country_id)
#  index_video_countries_on_video_id    (video_id)
#
