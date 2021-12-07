module Pro
  class Api::V3::ClassImageSerializer < ApplicationSerializer
    attributes :id, :image_original_url, :thumbnail_original_url
  end
end
