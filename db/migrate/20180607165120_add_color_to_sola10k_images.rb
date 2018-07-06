class AddColorToSola10kImages < ActiveRecord::Migration
  def change
  	unless ActiveRecord::Base.connection.column_exists?('sola10k_images', 'color')
    	add_column :sola10k_images, :color, :string
  	end
  end
end
