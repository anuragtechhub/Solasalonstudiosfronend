class AddRatingTimestampsToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :internal_rating_popup_showed_at, :datetime
    add_column :devices, :native_rating_popup_showed_at, :datetime
    add_column :devices, :internal_feedback, :text
  end
end
