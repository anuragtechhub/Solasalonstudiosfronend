namespace :surveys do

  task :locations => :environment do
    update_sites
    send_surveys
  end

  task :send_survey_test => :environment do 
    response = send_survey('jeff2@jeffbail.com', 'abq_paseo', 3846)

    p "response=#{response}"
  end

  def send_surveys
    Stylist.where(:status => 'open').each do |stylist|
      if stylist.email_address.present? && stylist.location.present? && stylist.location.url_name.present?
        begin
          p "send survey to #{stylist.email_address}, #{stylist.location.url_name}"
          send_survey(stylist.email_address, stylist.location.url_name, 3846)
        rescue
          p "error sending survey to #{stylist.email_address}"
        end
      end
    end
  end

  def send_survey(email, site_code, survey_id)
    `curl -i -H 'Accept: application/vnd.customersure.v1+json;' \
        -H 'Authorization: Token token="#{ENV['CUSTOMER_SURE_API_KEY']}"' \
        -H 'Content-Type: application/json' \
        -X POST \
        -d '{
              "email":"#{email}",
              "send_at":"#{DateTime.now.to_s}",
              "survey_id":#{survey_id},
              "email_template_id":106,
              "query_params":[{"key": "site_code", "value": "#{site_code}"}]
            }' \
       https://api.customersure.com/feedback_requests`
  end

  task :update_sites => :environment do 
    update_sites
  end

  task :update_site_test => :environment do
    sync_location('sobo', 'Salon SoBo', 'Denver', 'Colorado')
  end

  def update_sites
    Location.all.each do |location|
      sync_location(location.url_name, location.name, location.city, location.state) if location.url_name.present? && location.name.present? && location.city.present? && location.state.present?
    end
  end

  def sync_location(site_code, name, city, state)
    p "sync location #{site_code}, #{name}, #{city}, #{state}"
    
    get_site_response = JSON.parse(get_site(site_code))
    
    if get_site_response['message']
      # create
      p "create"
      response = create_site(site_code, name, city, state)
    else
      # update
      p "update"
      response = update_site(site_code, name, city, state)
    end

    p "response=#{response}"
  end

  def get_site(site_code)
    `curl -H 'Accept: application/vnd.customersure.v1+json;' \
     -H 'Authorization: Token token="#{ENV['CUSTOMER_SURE_API_KEY']}"' \
     https://api.customersure.com/sites/#{site_code}`
  end

  def update_site(site_code, name, city, state)
    `curl -i -H 'Accept: application/vnd.customersure.v1+json;' \
        -H 'Authorization: Token token="#{ENV['CUSTOMER_SURE_API_KEY']}"' \
        -H 'Content-Type: application/json' \
        -X PATCH \
        -d '{
              "site_code": "#{site_code}",
              "name": "#{name}",
              "city": "#{city}",
              "region": "#{state}"
            }' \
       https://api.customersure.com/sites/#{site_code}`
  end

  def create_site(site_code, name, city, state)
    `curl -i -H 'Accept: application/vnd.customersure.v1+json;' \
        -H 'Authorization: Token token="#{ENV['CUSTOMER_SURE_API_KEY']}"' \
        -H 'Content-Type: application/json' \
        -X POST \
        -d '{
              "site_code": "#{site_code}",
              "name": "#{name}",
              "city": "#{city}",
              "region": "#{state}"
            }' \
       https://api.customersure.com/sites`
  end

end