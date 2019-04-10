Gridhook.configure do |config|
  # The path we want to receive events
  config.event_receive_path = '/sendgrid/event'

  config.event_processor = proc do |event|
    # event is a Gridhook::Event object
    p "SENDGRID EVENT PROCESSOR #{event.attributes.inspect}"
    #EmailEvent.create! event.attributes.except('smtp-id', 'url-offset', 'url_offset', 'type')
    event_attributes = event.attributes.select {|k,v| ['category', 'email', 'event', 'ip', 'response', 'sg_event_id', 'sg_message_id', 'smtp_id', 'timestamp', 'useragent', 'url', 'status', 'reason', 'attempt', 'tls'].include?(k) }
    
    # handle category
    if event_attributes['category'].kind_of?(Array)
    	event_attributes['category'] = event_attributes['category'][0]
    end

    EmailEvent.create! event_attributes
  end
end

