Gridhook.configure do |config|
  # The path we want to receive events
  config.event_receive_path = '/sendgrid/event'

  config.event_processor = proc do |event|
    # event is a Gridhook::Event object
    p "SENDGRID EVENT PROCESSOR #{event.attributes.inspect}"
    #EmailEvent.create! event.attributes.except('smtp-id', 'url-offset', 'url_offset', 'type')
    EmailEvent.create! event.attributes.select {|k,v| ['category', 'email', 'event', 'ip', 'response', 'sg_event_id', 'sg_message_id', 'smtp_id', 'timestamp', 'useragent', 'url', 'status', 'reason', 'attempt', 'tls'].include?(k) }
  end
end

