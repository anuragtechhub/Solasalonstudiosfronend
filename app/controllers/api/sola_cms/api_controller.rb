class Api::SolaCms::ApiController < ActionController::Base  
  before_action :restrict_api_access, :set_cors_headers
  rescue_from StandardError, with: :error_render_method
  
  protected

  def restrict_api_access
    account = Account.find_by(api_key: request.headers["api-key"])
    render json: { api_key: ['invalid'] }, status: :unprocessable_entity unless account
  end

  def set_cors_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
  end

  def pagination_details(collection)
    {
      current_page: collection.current_page,
      next_page: collection.next_page,
      prev_page: collection.prev_page, # use collection.previous_page when using will_paginate
      total_pages: collection.total_pages,
      current_count: collection.length,
      total_count: collection.total_count # use collection.total_entries when using will_paginate
    } if collection.present?
  end

  def paginate(collection)
    page = params[:page] || 1
    per_page = params[:per_page] || 20
    if collection.kind_of?(Array)
      Kaminari.paginate_array(collection)
    else
      collection
    end&.page(page).per(per_page)
  end

  def order
    params[:order_by].presence || 'DESC'
  end

  def field
    params[:field].presence || 'created_at'
  end

  def error_render_method(exception)
    render json: {error: exception.message}, status: 400
  end
end
