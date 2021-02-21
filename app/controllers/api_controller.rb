class ApiController < ApplicationController

  skip_before_action :verify_authenticity_token

  before_filter :restrict_api_access

  protected

  def restrict_api_access
    account = Account.find_by(:api_key => params[:api_key])
    render :json => {api_key: ['invalid']}, :status => :unprocessable_entity unless account
  end

  def set_cache_headers
    response.headers["Cache-Control"]='max-age=300'
  end
end
