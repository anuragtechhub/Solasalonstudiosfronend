class AddSubjectToReports < ActiveRecord::Migration
  def change
    add_column :reports, :subject, :string
  end
end
