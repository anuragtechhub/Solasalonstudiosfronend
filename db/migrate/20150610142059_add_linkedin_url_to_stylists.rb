class AddLinkedinUrlToStylists < ActiveRecord::Migration
  def change
    add_column :stylists, :linkedin_url, :string
  end
end
