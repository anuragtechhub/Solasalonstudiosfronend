module ApplicationHelper

  def valid_email?(email = nil)
    email && email =~ /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  end

  def url_helper(url = '')
    unless url && url.starts_with?('http')
      url = 'http://' + url;
    end
    
    url = url.gsub(/http\/\/www/, 'http://www')
    url = url.gsub(/https\/\/www/, 'https://www')

    url
  end
end
