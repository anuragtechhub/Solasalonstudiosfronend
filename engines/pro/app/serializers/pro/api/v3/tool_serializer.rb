# frozen_string_literal: true

module Pro
  class Api::V3::ToolSerializer < ApplicationSerializer
    attributes :id, :title, :image_url, :file_url, :file_content_type, :views

    belongs_to :brand
    has_many :categories
  end
end
