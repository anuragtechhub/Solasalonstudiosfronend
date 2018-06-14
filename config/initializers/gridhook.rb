Gridhook.configure do |config|
  # The path we want to receive events
  config.event_receive_path = '/sendgrid/event'

  config.event_processor = proc do |event|
    # event is a Gridhook::Event object
    #p "SENDGRID EVENT PROCESSOR #{event.attributes.inspect}"
    EmailEvent.create! event.attributes.except('smtp-id')
  end
end