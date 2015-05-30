module ApplicationHelper

  def valid_email?(email = nil)
    email && email =~ /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
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
end
