# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://www.solasalonstudios.com"

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
  # TODO: dynamic models

  add '/testimonials'

  add '/faq'

  add '/gallery'

  add '/sessions'

  add '/mysola'

  # Put links creation logic here.
  #
  
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end
end
