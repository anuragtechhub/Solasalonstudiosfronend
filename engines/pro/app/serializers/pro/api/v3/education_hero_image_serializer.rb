module Pro
  class Api::V3::EducationHeroImageSerializer < ApplicationSerializer
    attributes :id, :action_link, :position
    attributes :image_original_url
  end
end

  # Table name: education_hero_images
  #
  #  id                 :integer          not null, primary key
  #  action_link        :string(255)
  #  image_content_type :string(255)
  #  image_file_name    :string(255)
  #  image_file_size    :integer
  #  image_updated_at   :datetime
  #  position           :integer
  #  created_at         :datetime
  #  updated_at         :datetime
  #
