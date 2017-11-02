class CreateRecurringCharges < ActiveRecord::Migration
  def change
    unless ActiveRecord::Base.connection.table_exists?(:recurring_charges)
      create_table :recurring_charges do |t|
        t.integer :amount
        t.date :start_date
        t.date :end_date

        t.timestamps
      end
    end
  end
end
