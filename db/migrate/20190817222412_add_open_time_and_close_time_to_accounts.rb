class AddOpenTimeAndCloseTimeToAccounts < ActiveRecord::Migration
  def change
    add_column :locations, :open_time, :time
    add_column :locations, :close_time, :time
  end
end
