namespace :blog do

  task :publish => :environment do
    Blog.where('status = ? AND publish_date <= ?', 'draft', DateTime.now).each do |blog|
      blog.status = 'published'
      blog.save
    end
  end

  task :fix_publish_dates => :environment do
    Blog.where(:publish_date => nil, :status => 'published').each do |blog|
      p "blog, #{blog.id}, #{blog.title}"
      blog.publish_date = blog.created_at
      blog.save
    end
  end

  task :hyphenate_posts => :environment do
    Blog.all.each do |blog|
      p "blog url before=#{blog.url_name}, after=#{blog.fix_url_name}"
      blog.save
    end
  end

  task :hyphenate_categories => :environment do
    BlogCategory.all.each do |category|
      p "category url before=#{category.url_name}, after=#{category.fix_url_name}"
      category.save
    end
  end

end