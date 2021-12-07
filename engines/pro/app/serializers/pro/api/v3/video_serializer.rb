module Pro
  class Api::V3::VideoSerializer < ApplicationSerializer
    attributes :id, :title, :image_url,
                     :youtube_url, :duration, :views, :webinar

    has_many :categories
    belongs_to :brand
  end
end