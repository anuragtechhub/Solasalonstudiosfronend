# frozen_string_literal: true

namespace :countries do
  # creates all countries
  task create: :environment do
    Country.find_or_create_by(name: 'United States', code: 'US', domain: 'solasalonstudios.com')
    Country.find_or_create_by(name: 'Canada', code: 'CA', domain: 'solasalonstudios.ca')
  end

  # assigns all blogs to United States
  task blogs_to_us: :environment do
    usa = Country.find_by(code: 'US')
    Blog.all.each do |blog|
      blog.countries << usa unless blog.countries.any? { |c| c.code == 'US' }
    end
  end
end
