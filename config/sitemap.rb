# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://www.solasalonstudios.com"
 SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new(fog_provider: 'AWS',
                                         aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
                                         aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
                                         fog_directory: 'solasitemap',
                                         fog_region: 'us-east-1')
SitemapGenerator::Sitemap.public_path = 'tmp/'
SitemapGenerator::Sitemap.sitemaps_host = "http://solasitemap.s3.amazonaws.com/"
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'
SitemapGenerator::Sitemap.compress = false
SitemapGenerator::Sitemap.create do
  # the root path '/' and sitemap index file are added automatically for you.

  add '/own-your-salon'
  add '/own/own-your-salon'
  add '/own/studio-amenities'
  add '/own/sola-pro'
  add '/own/sola-sessions'

  add '/about-us'

  add '/locations'
  Location.where(:status => 'open').find_each do |location|
    add location.canonical_path, :lastmod => location.updated_at
  end

  # states
  Location.distinct(:state).pluck(:state).each do |state|
    url = state.split(/_|\s/)
    url = url.map{|u| u.downcase}
    url = url.join('-')

    add "/states/#{url}"
  end

  Msa.find_each do |msa|
    add msa.canonical_path
  end

  add '/salon-professionals'
  Stylist.where(:status => 'open').find_each do |stylist|
    add stylist.canonical_path, :lastmod => stylist.updated_at
  end

  add '/blog'
  Blog.where(:status => 'published').find_each do |blog|
    add blog.canonical_path, :lastmod => blog.updated_at
  end

  add '/contact-us'

  add '/news'

  add '/testimonials'

  #add '/faq'

  add '/gallery'

  add '/sessions'

  add '/mysola'

  add '/diversity'

  add '/privacy-policy'
  
end
