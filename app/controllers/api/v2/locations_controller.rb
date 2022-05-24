# frozen_string_literal: true

class Api::V2::LocationsController < ApiController
  before_action :set_cors_headers
  before_action :set_cache_headers
  before_action :store_gloss_genius_logs, only: %i[show] , if: -> { ENV['LOG_GLOSS_GENIUS_LOCATION'] == "true" }

  def index
    cache_key = "/api/v2/index/#{Location.maximum(:updated_at).to_i}"
    json = Rails.cache.fetch(cache_key, expires_in: 12.hours) do
      @locations = Location.open.order(:created_at)
      result = ActiveModelSerializers::SerializableResource.new(
        @locations,
        each_serializer: Api::V2::LocationSerializer
      ).as_json
      result[:data] = result.delete(:locations)
      render_to_string json: result
    end
    render json: json
  end

  def show
    scope = Stylist.where(location_id: params[:id]).active.not_reserved
    cache_key = "/api/v2/show/#{params[:id]}/#{Location.maximum(:updated_at).to_i}-#{scope.maximum(:updated_at).to_i}"
    json = Rails.cache.fetch(cache_key, expires_in: 12.hours) do
      result = ActiveModelSerializers::SerializableResource.new(
        scope,
        each_serializer: Api::V2::StylistSerializer
      ).as_json
      result[:data] = result.delete(:stylists)
      render_to_string json: result
    end
    render json: json
  end

  private

    def store_gloss_genius_logs
      store_gloss_genius_log = GlossGeniusLog.create(action_name: request[:action], ip_address: request.remote_ip, host: request.host, request_body: params)
    end 
end
