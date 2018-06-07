class AddColorToSola10kImages < ActiveRecord::Migration
  def change
    add_column :sola10k_images, :color, :string
  end
end
