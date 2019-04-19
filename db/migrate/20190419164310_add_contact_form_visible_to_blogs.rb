class AddContactFormVisibleToBlogs < ActiveRecord::Migration
  def change
    add_column :blogs, :contact_form_visible, :boolean, :default => false
  end
end
