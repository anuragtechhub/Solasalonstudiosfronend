class RenameYourProfessionToMarket < ActiveRecord::Migration
  def change
    rename_column :franchising_requests, :profession, :market
  end
end
