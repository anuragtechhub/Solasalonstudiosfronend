class AddParametersToReports < ActiveRecord::Migration
  def change
    add_column :reports, :parameters, :string
  end
end
