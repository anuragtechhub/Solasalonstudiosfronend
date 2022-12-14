# frozen_string_literal: true

class Api::V3::RentManagerWebhooksController < ApiController
  skip_before_action :restrict_api_access

  def create
    RentManager::Event.create!(body: params)
    head :no_content
  rescue ActiveRecord::RecordInvalid => e
    Rollbar.error(e)
    NewRelic::Agent.notice_error(e)
  end
end
