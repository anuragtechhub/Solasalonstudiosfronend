# frozen_string_literal: true

namespace :blog do
  task publish: :environment do
    Blog.draft.where('publish_date <= ?', Time.current).update_all(status: 'published')
  end
end
