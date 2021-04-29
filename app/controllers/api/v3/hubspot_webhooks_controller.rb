class Api::V3::HubspotWebhooksController < ApiController
  skip_before_filter :restrict_api_access

  def create
    check_credentials
    HubspotEvent.create!(event_params)
  rescue ActiveRecord::RecordInvalid => e
    Rollbar.error(e)
    NewRelic::Agent.notice_error(e)
  end

  private

  def event_params
    params.permit(webhook: {}).tap do |permitted|
      permitted[:kind]     = params[:type]
      permitted[:data]     = permitted.delete(:webhook)
      permitted[:fired_at] = Time.current
    end
  end

  def check_credentials
    # TODO: Verify request signatures in workflow webhooks
    # https://knowledge.hubspot.com/workflows/how-do-i-use-webhooks-with-hubspot-workflows
    raise AccessDenied unless params.delete(:key) == ENV.fetch('HUBSPOT_WEBHOOK_KEY')
  end
end
