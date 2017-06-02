module ApplicationHelper

  require 'uri'

  def valid_email?(email = nil)
    email && email =~ /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  end

  def valid_url?(url = nil)
    url && URI.parse(url)
  rescue URI::InvalidURIError
    false
  end

  def url_helper(url = '')
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

  def beautify_url_segment(url)
    #url = url.gsub('___', '_')
    #url = url.gsub('_-_', '_')
    #url = url.gsub(/[^0-9a-zA-Z]/, '_')
    url = url.split(/_|\s/)
    url = url.map{|u| u.downcase}
    url.join('-')
  end
  
end
