require 'test_helper'

class ClassImageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

# == Schema Information
#
# Table name: class_images
#
#  id                     :integer          not null, primary key
#  image_content_type     :string(255)
#  image_file_name        :string(255)
#  image_file_size        :integer
#  image_updated_at       :datetime
#  name                   :string(255)
#  thumbnail_content_type :string(255)
#  thumbnail_file_name    :string(255)
#  thumbnail_file_size    :integer
#  thumbnail_updated_at   :datetime
#  created_at             :datetime
#  updated_at             :datetime
#
