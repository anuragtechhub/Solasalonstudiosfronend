class MigrateFromSgBookingUrl < ActiveRecord::Migration
  def change
    Stylist.where.not(sg_booking_url:'').find_each {|st| st.update_attribute(:booking_url, st.sg_booking_url)}
    # remove_column :stylists, :sg_booking_url
  end
end
