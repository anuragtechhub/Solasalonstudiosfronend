class CreateRequestTourInquiries < ActiveRecord::Migration
  def change
    create_table :request_tour_inquiries do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.references :location, index: true

      t.timestamps
    end
  end
end
