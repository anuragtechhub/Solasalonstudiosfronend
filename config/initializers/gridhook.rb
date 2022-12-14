# frozen_string_literal: true

Gridhook.configure do |config|
  # The path we want to receive events
  config.event_receive_path = '/sendgrid/event'

  config.event_processor = proc do |event|
    # event is a Gridhook::Event object
    Rails.logger.debug { "SENDGRID EVENT PROCESSOR #{event.attributes.inspect}" }
    # EmailEvent.create! event.attributes.except('smtp-id', 'url-offset', 'url_offset', 'type')
    event_attributes = event.attributes.select { |k, _v| %w[category email event ip response sg_event_id sg_message_id smtp_id timestamp useragent url status reason attempt tls].include?(k) }

    # handle category
    if event_attributes['category'].is_a?(Array)
      event_attributes['category'] = event_attributes['category'][0]
    end

    EmailEvent.create! event_attributes
  end
end
