class AddMsaIndex < ActiveRecord::Migration
  def change
    add_index :msas, :name
    add_index :msas, :url_name
  end
end
