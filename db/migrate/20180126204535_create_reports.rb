class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string :report_type
      t.string :email_address
      t.datetime :processed_at

      t.timestamps
    end
  end
end
