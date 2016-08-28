class AddLocationToArticles < ActiveRecord::Migration
  def change
    add_reference :articles, :location, index: true
  end
end
