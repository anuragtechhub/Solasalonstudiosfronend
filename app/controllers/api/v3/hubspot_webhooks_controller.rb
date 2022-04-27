# frozen_string_literal: true

class Api::V3::HubspotWebhooksController < ApiController
  skip_before_action :restrict_api_access

  def create
    check_credentials
    HubspotEvent.create!({ data: params, fired_at: Time.current, kind: 'deal' })
    head :no_content
  rescue ActiveRecord::RecordInvalid => e
    Rollbar.error(e)
    NewRelic::Agent.notice_error(e)
  end

  private

    def check_credentials
      # TODO: Verify request signatures in workflow webhooks
      # https://knowledge.hubspot.com/workflows/how-do-i-use-webhooks-with-hubspot-workflows
      raise AccessDenied unless params.delete(:key) == ENV.fetch('HUBSPOT_WEBHOOK_KEY')
    end
end
