# frozen_string_literal: true

module ApplicationHelper
  require 'uri'

  def valid_email?(email = nil)
    email && email =~ /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  end

  def valid_url?(url = nil)
    url && URI.parse(url.strip)
  rescue URI::InvalidURIError => e
    NewRelic::Agent.notice_error(e)
    Rollbar.error(e)
    false
  end

  # looks like piece of shit
  def url_helper(url = '')
    return url unless url.is_a?(String)

    url = url.strip
    url = url.gsub(%r{http://https://}, 'http://')
    url = url.gsub(%r{https://https://}, 'http://')
    url = url.gsub(%r{https://http://}, 'http://')
    url = url.gsub(%r{http//www}, 'http://www')
    url = url.gsub(%r{https//www}, 'https://www')

    unless url && (url.starts_with?('http') || url.starts_with?('https'))
      url = "http://#{url}"
    end

    url
  end

  def clean_html(str)
    return '' unless str

    str = strip_tags(str)
    str = str.gsub(/&#39;/, "'")
    str = str.gsub(/&quot;/, "'")
    str = str.gsub(/&amp;/, '&')
    str = str.gsub(/&#8217;/, "'")

    str.html_safe
  end

  # bullshit
  def beautify_url_segment(url)
    url.downcase.strip.gsub(/\s+/, '_').gsub('_', '-')
  end

  def root_sola_domain
    case request.domain
    when 'solasalonstudios.ca' # || request.domain == 'localhost'
      'solasalonstudios.ca'
    when 'com.br', 'com.br/' # || request.domain == 'localhost'
      'solasalonstudios.com.br'
    else
      'solasalonstudios.com'
    end
  end

  def canadian_locale?
    I18n.locale.to_s == 'en-CA'
  end

  def brazilian_locale?
    I18n.locale.to_s == 'pt-BR'
  end

  def english_locale?
    I18n.locale.to_s == 'en'
  end
end
