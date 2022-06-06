class Api::SolaCms::ApiController < ActionController::Base
  before_action :restrict_api_access, :set_cors_headers
  
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
end
