class CreateLeases < ActiveRecord::Migration
  def change
    create_table :leases do |t|
      t.references :stylist, index: true
      t.references :studio, index: true
      t.string :rent_manager_id, index: true
      t.date :start_date
      t.date :end_date
      t.date :move_in_date
      t.date :signed_date
      t.integer :weekly_fee_year_1
      t.integer :weekly_fee_year_2
      t.date :fee_start_date
      t.integer :damage_deposit_amount
      t.integer :product_bonus_amount
      t.string :product_bonus_distributor
      t.boolean :sola_provided_insurance
      t.string :sola_provided_insurance_frequency
      t.text :special_terms
      t.boolean :ach_authorized

      t.timestamps
    end
  end
end
