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

end