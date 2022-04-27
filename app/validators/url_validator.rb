# frozen_string_literal: true

class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    begin
      uri = URI.parse(value)
      resp = uri.is_a?(URI::HTTP)
    rescue URI::InvalidURIError => e
      Rollbar.error(e)
      NewRelic::Agent.notice_error(e)
      resp = false
    end
    unless resp == true
      record.errors[attribute] << (options[:message] || 'is not an url')
    end
  end
end
