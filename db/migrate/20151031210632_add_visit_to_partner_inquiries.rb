class AddVisitToPartnerInquiries < ActiveRecord::Migration
  def change
    add_reference :partner_inquiries, :visit, index: true
  end
end
