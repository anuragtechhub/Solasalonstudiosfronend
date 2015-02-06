class AddLegacyIdToBlogs < ActiveRecord::Migration
  def change
    add_column :blogs, :legacy_id, :string
  end
end
