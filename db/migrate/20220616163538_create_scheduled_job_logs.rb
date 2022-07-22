class CreateScheduledJobLogs < ActiveRecord::Migration
  def change
    create_table :scheduled_job_logs do |t|
      t.json :data
      t.datetime :fired_at
      t.integer :status
      t.string :kind
      t.string :action
      t.timestamps
    end
  end
end
