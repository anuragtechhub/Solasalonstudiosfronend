module Pro
  class Api::V3::BrandShowSerializer < ApplicationSerializer
    attributes :id, :name, :image_url
    attribute :introduction_video

    has_many :deals
    has_many :videos
    has_many :tools do
      @object.tools.with_file
    end
  end
end

  # == Schema Information
  #
  # Table name: brands
  #
  #  id                               :integer          not null, primary key
  #  events_and_classes_heading_title :string(255)      default("Classes")
  #  image_content_type               :string(255)
  #  image_file_name                  :string(255)
  #  image_file_size                  :integer
  #  image_updated_at                 :datetime
  #  introduction_video_heading_title :string(255)      default("Introduction")
  #  name                             :string(255)
  #  website_url                      :string(255)
  #  white_image_content_type         :string(255)
  #  white_image_file_name            :string(255)
  #  white_image_file_size            :integer
  #  white_image_updated_at           :datetime
  #  created_at                       :datetime
  #  updated_at                       :datetime
  #
