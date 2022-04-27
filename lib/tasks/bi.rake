# frozen_string_literal: true

namespace :bi do
  task stylists_with_non_hair_services: :environment do
    p 'Begin stylists_with_non_hair_services...'
    CSV.open(Rails.root.join('csv', 'stylists_with_non_hair_services.csv'), 'wb') do |csv|
      csv << ['Name', 'Email Address', 'Phone Number', 'Location Name', 'Location City', 'Skin', 'Nails', 'Massage', 'Microblading', 'Makeup', 'Waxing', 'Brows']
      Stylist.where(status: 'open').each do |stylist|
        next unless stylist.location&.name

        p "adding stylist #{stylist.name}, #{stylist.email_address}"

        csv << [stylist.name, stylist.email_address, stylist.phone_number, stylist.location.name, stylist.location.city, stylist.skin, stylist.nails, stylist.massage, stylist.microblading, stylist.makeup, stylist.waxing, stylist.brows]
      end
    end
    p 'End stylists_with_non_hair_services'
  end

  task all_stylists: :environment do
    CSV.open(Rails.root.join('csv', 'all_stylists.csv'), 'wb') do |csv|
      csv << ['Location Name', 'Location City', 'Location State', 'Stylist Name', 'Stylist Phone Number', 'Stylist Email Address', 'Stylist Created At']
      Location.where(status: 'open').each do |location|
        p "location=#{location.name}, #{location.city}, #{location.state}"
        location.stylists.each do |stylist|
          csv << [location.name, location.city, location.state, stylist.name, stylist.phone_number, stylist.email_address, stylist.created_at]
        end
      end
    end
  end

  task stylists_in_california: :environment do
    CSV.open(Rails.root.join('csv', 'stylists_in_california.csv'), 'wb') do |csv|
      Location.where(status: 'open').where('lower(state) = ?', 'california').where(country: 'US').each do |location|
        p "location=#{location.name}, #{location.city}, #{location.state}"
        location.stylists.each do |stylist|
          csv << [location.name, stylist.name, stylist.phone_number, stylist.email_address]
        end
      end
    end
  end

  task sola_pro_sola_genius_penetration: :environment do
    p 'Begin sola_pro_sola_genius_penetration...'
    CSV.open(Rails.root.join('csv', 'sola_pro_sola_genius_penetration.csv'), 'wb') do |csv|
      csv << ['Location Name', 'City', 'State', 'Stylists on Website', 'Stylists with Sola Pro Account', 'Stylists with SolaGenius Account']
      Location.where(status: 'open').order(:created_at).each do |location|
        p "location=#{location.name}, #{location.stylists.length}"
        csv << [location.name, location.city, location.state, location.stylists.length, location.stylists_using_sola_pro.length, location.stylists_using_sola_genius.length]
        # csv << [location.name, location.city, location.state, location.stylists.size, location.stylists.where("encrypted_password != ''").size, location.stylists.where('stylists.has_sola_genius_account = ?', true).size]
        p "done with #{location.name}"
      end
    end
  end
end
