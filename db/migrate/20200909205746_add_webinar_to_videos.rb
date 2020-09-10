class AddWebinarToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :webinar, :boolean, default: false

    Video.find_each do |v|
      if 'Past Webinars'.in?(v.video_categories.map(&:name))
        v.update_attribute(:webinar, true)
      end
    end
  end
end
