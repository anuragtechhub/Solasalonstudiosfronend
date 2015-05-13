class CreateFranchisingRequests < ActiveRecord::Migration
  def change
    create_table :franchising_requests do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.string :profession
      t.text :message
      t.string :preferred_method_of_contact

      t.timestamps
    end
  end
end
