# frozen_string_literal: true

Paperclip::UriAdapter.register
Paperclip::DataUriAdapter.register
Paperclip::HttpUrlProxyAdapter.register
Paperclip::Attachment.default_options[:default_url] = nil
