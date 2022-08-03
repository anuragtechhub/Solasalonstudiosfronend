class AddActivestartAndEndDateToExternalId < ActiveRecord::Migration
  def change
    add_column :external_ids, :active_start_date, :datetime
    add_column :external_ids, :active_end_date, :datetime
    add_column :external_ids, :matching_category, :string
  end
end
