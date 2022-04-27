# frozen_string_literal: true

module Pro
  class Api::V3::EducationHeroImagesController < Api::V3::ApiController
    load_and_authorize_resource only: %i[index]

    def index
      respond_with(paginate(@education_hero_images.order(position: :asc)))
    end
  end
end
