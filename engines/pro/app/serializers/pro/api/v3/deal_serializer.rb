module Pro
  class Api::V3::DealSerializer < ApplicationSerializer
    attributes :id, :title, :description, :image_url, :file_url, :more_info_url, :views
    belongs_to :brand
    has_many :categories
  end
end