module Pro
  class Api::V3::CategoriesController < Api::V3::ApiController
    load_and_authorize_resource :category, only: %i[index]

    def index
      respond_with(@categories)
    end
  end
end