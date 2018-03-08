class AddForceShowBookNowButtonToStylists < ActiveRecord::Migration
  def change
    add_column :stylists, :force_show_book_now_button, :boolean, :default => false
  end
end
