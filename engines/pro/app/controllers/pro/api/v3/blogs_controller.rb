# frozen_string_literal: true

module Pro
  class Api::V3::BlogsController < Api::V3::ApiController
    load_and_authorize_resource only: %i[index show]

    def index
      @blogs = @blogs.published.includes(:countries).where(countries: { code: current_user.location_country })
      @blogs = @blogs.search(params[:q]) if params[:q].present?
      @blogs = @blogs.where(id: Blog.includes(:categories).where(categories: { id: params[:category_id] }).select(:id)) if params[:category_id].present?
      respond_with(paginate(@blogs.order(created_at: :desc)), include: '**')
    end

    def show
      respond_with(@blog, include: '**')
    end
  end
end
