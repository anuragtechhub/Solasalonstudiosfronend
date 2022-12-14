# frozen_string_literal: true

namespace :stylist do
  task hyphenate: :environment do
    Stylist.all.each do |stylist|
      p "stylist url before=#{stylist.url_name}, after=#{stylist.fix_url_name}"
      stylist.update_columns(url_name: stylist.url_name)
    end
  end

  task turn_off_walkins: :environment do
    Stylist.where('walkins = ? AND walkins_expiry IS NOT NULL', true).each do |stylist|
      offset = stylist.location.walkins_offset
      now = DateTime.now.change(offset: offset)
      walkins_expiry = DateTime.parse(stylist.walkins_expiry.to_s).change(offset: offset)

      p "now=#{now}, walkins_expiry=#{walkins_expiry}"
      if walkins_expiry <= now
        p "gotta turn off walkins for #{stylist.id}, #{stylist.email_address}"
        if stylist.update(walkins: false, walkins_expiry: nil)
          p 'walkins settings for stylist updated successfully!'
        else
          p "walkins settings for stylist NOT updated successfully: #{stylist.errors.inspect}"
        end
      end
    rescue StandardError => e
      Rollbar.error(e)
      NewRelic::Agent.notice_error(e)
      p "error updating walkins settings for stylist #{stylist.id}, #{e}"
    end
  end
end
