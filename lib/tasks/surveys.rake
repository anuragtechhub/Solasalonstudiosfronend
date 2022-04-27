# frozen_string_literal: true

namespace :surveys do
  task locations: :environment do
    # update_sites
    send_surveys
  end

  task send_survey_test: :environment do
    response = send_survey('adam@solasalonstudios.com', 'sola_hq', 3846)

    p "response=#{response}"
  end

  task send_test: :environment do
    tomorrow = DateTime.now.tomorrow.change({ hour: 10, min: 0, sec: 0 }).to_s
    Stylist.where(status: 'open', location_id: [167, 168]).each do |stylist|
      next unless stylist.email_address.present? && stylist.location.present? && stylist.location.url_name.present?

      begin
        p "send survey to #{stylist.email_address}, #{stylist.location.url_name}, #{tomorrow}"
        send_survey(stylist.email_address, stylist.location.url_name, 3846, tomorrow)
        sleep 1
      rescue StandardError => e
        Rollbar.error(e)
        NewRelic::Agent.notice_error(e)
      end
    end
  end

  task survey_location: :environment do
    Stylist.where(status: 'open', location_id: 65).order(:id).each do |stylist|
      if stylist.email_address.present? && stylist.location.present? && stylist.location.url_name.present?
        begin
          p "send survey to #{stylist.id}, #{stylist.email_address}, #{stylist.location.url_name}"
          send_survey(stylist.email_address.strip, stylist.location.url_name.strip, 3846)
          sleep 1
        rescue StandardError => e
          Rollbar.error(e)
          NewRelic::Agent.notice_error(e)
        end
      else
        p 'not sending survey because the stylist email or location or something is not present'
      end
    end
  end

  def send_surveys
    Stylist.where(status: 'open').order(:id).each_with_index do |stylist, idx|
      next unless stylist.email_address.present? && stylist.location.present? && stylist.location.url_name.present?

      begin
        p "send survey #{idx + 1} to #{stylist.id}, #{stylist.email_address.strip}, #{stylist.location.url_name.strip}, #{stylist.location.id}"
        response = send_survey(stylist.email_address.strip, stylist.location.url_name.strip, 3846)
        p response.to_s
        p ''
        p '* * * * * * * * * * * *'
        sleep 1
      rescue StandardError => e
        Rollbar.error(e)
        NewRelic::Agent.notice_error(e)
        p "error sending survey to #{stylist.email_address} #{e}"
      end
    end
  end

  def send_survey(email, site_code, survey_id, date = DateTime.now.to_s)
    require 'uri'

    `curl -i -H 'Accept: application/vnd.customersure.v1+json;' \
        -H 'Authorization: Token token="#{ENV.fetch('CUSTOMER_SURE_API_KEY', nil)}"' \
        -H 'Content-Type: application/json' \
        -X POST \
        -d '{
              "email":"#{email}",
              "send_at":"#{date}",
              "survey_id":#{survey_id},
              "email_template_id":106,
              "query_params":[{"key": "site_code", "value": "#{site_code}"}]
            }' \
       https://api.customersure.com/feedback_requests`
  end

  task update_sites: :environment do
    update_sites
  end

  task update_site: :environment do
    location = Location.find(281) # college station
    begin
      sync_location(location.url_name.strip, location.name.strip, location.city, location.state)
    rescue StandardError => e
      Rollbar.error(e)
      NewRelic::Agent.notice_error(e)
      p "error syncing location #{e.inspect}"
    end
  end

  task update_site_test: :environment do
    sync_location('sola_hq', 'Sola HQ', 'Denver', 'Colorado')
  end

  def update_sites
    Location.all.each do |location|
      if location.url_name.present? && location.name.present? && location.city.present? && location.state.present?
        p "sync_location, #{location.url_name}, #{location.name}, #{location.city}, #{location.state}"
        sync_location(location.url_name.strip, location.name.strip, location.city, location.state)
        sleep 2
      end
    rescue StandardError => e
      Rollbar.error(e)
      NewRelic::Agent.notice_error(e)
      p 'error syncing location'
    end
  end

  def sync_location(site_code, name, city, state)
    p "sync location #{site_code}, #{name}, #{city}, #{state}"

    get_site_response = JSON.parse(get_site(site_code))

    if get_site_response['message']
      # create
      p 'create'
      response = create_site(site_code, name, city, state)
    else
      # update
      p 'update'
      response = update_site(site_code, name, city, state)
    end

    p "response=#{response}"
  end

  def get_site(site_code)
    `curl -H 'Accept: application/vnd.customersure.v1+json;' \
     -H 'Authorization: Token token="#{ENV.fetch('CUSTOMER_SURE_API_KEY', nil)}"' \
     https://api.customersure.com/sites/#{site_code}`
  end

  def update_site(site_code, name, city, state)
    require 'uri'

    `curl -i -H 'Accept: application/vnd.customersure.v1+json;' \
        -H 'Authorization: Token token="#{ENV.fetch('CUSTOMER_SURE_API_KEY', nil)}"' \
        -H 'Content-Type: application/json' \
        -X PATCH \
        -d '{
              "site_code": "#{site_code}",
              "name": "#{escape_string name}",
              "city": "#{escape_string city}",
              "region": "#{escape_string state}"
            }' \
       https://api.customersure.com/sites/#{site_code}`
  end

  def create_site(site_code, name, city, state)
    `curl -i -H 'Accept: application/vnd.customersure.v1+json;' \
        -H 'Authorization: Token token="#{ENV.fetch('CUSTOMER_SURE_API_KEY', nil)}"' \
        -H 'Content-Type: application/json' \
        -X POST \
        -d '{
              "site_code": "#{site_code}",
              "name": "#{escape_string name}",
              "city": "#{escape_string city}",
              "region": "#{escape_string state}"
            }' \
       https://api.customersure.com/sites`
  end

  def escape_string(str)
    # require 'uri'
    str.gsub(/'/, '')
    # str = URI.escape str
  end
end
