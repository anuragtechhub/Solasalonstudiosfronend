class AddTrackingCodeToMsas < ActiveRecord::Migration
  def change
    add_column :msas, :tracking_code, :text
  end
end
