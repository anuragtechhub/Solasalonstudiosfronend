class CreatePartnerInquiries < ActiveRecord::Migration
  def change
    create_table :partner_inquiries do |t|
      t.string :subject
      t.string :name
      t.string :company_name
      t.string :email
      t.string :phone
      t.text :message

      t.timestamps
    end
  end
end
