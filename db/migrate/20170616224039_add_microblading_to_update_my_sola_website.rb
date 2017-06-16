class AddMicrobladingToUpdateMySolaWebsite < ActiveRecord::Migration
  def change
    add_column :update_my_sola_websites, :microblading, :boolean
  end
end
