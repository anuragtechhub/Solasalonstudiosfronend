class UpdateBiographyToBeATextColumn < ActiveRecord::Migration
  def change
    change_column :update_my_sola_websites, :biography, :text
  end
end
