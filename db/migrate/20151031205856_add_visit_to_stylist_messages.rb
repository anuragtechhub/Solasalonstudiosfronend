class AddVisitToStylistMessages < ActiveRecord::Migration
  def change
    add_reference :stylist_messages, :visit, index: true
  end
end
