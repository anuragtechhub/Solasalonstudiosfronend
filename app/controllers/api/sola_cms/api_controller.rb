class Api::SolaCms::ApiController < ActionController::Base
  before_action :restrict_api_access
  
  protected

  def restrict_api_access
    account = Account.find_by(api_key: request.headers["api-key"])
    render json: { api_key: ['invalid'] }, status: :unprocessable_entity unless account
  end
end
