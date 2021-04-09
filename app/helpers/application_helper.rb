module ApplicationHelper

  require 'uri'

  def valid_email?(email = nil)
    email && email =~ /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  end

  def valid_url?(url = nil)
    url && URI.parse(url)
  rescue URI::InvalidURIError => e
    NewRelic::Agent.notice_error(e)
    Rollbar.error(e)
    false
  end

  def url_helper(url = '')
    return url unless url.is_a?(String)

    url = url.gsub(/http:\/\/https:\/\//, 'http://')
    url = url.gsub(/https:\/\/https:\/\//, 'http://')
    url = url.gsub(/https:\/\/http:\/\//, 'http://')
    url = url.gsub(/http\/\/www/, 'http://www')
    url = url.gsub(/https\/\/www/, 'https://www')

    unless url && (url.starts_with?('http') || url.starts_with?('https'))
      url = 'http://' + url;
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
    url.downcase.strip.gsub(/\s+/,'_').gsub('_', '-')
  end

  def root_sola_domain
    if request.domain == 'solasalonstudios.ca' #|| request.domain == 'localhost'
      'solasalonstudios.ca'
    elsif request.domain == 'com.br' || request.domain == 'com.br/' #|| request.domain == 'localhost'
      'solasalonstudios.com.br'
    else
      'solasalonstudios.com'
    end
  end

end
