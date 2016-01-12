namespace :surveys do

  task :locations => :environment do
    Stylist.where(:status => 'open').each do |stylist|
      if stylist.email_address && stylist.email_address.present?
        begin
          p "send survey to #{stylist.email_address}"
          send_survey(stylist.email_address, 3846)
        rescue
          p "error sending survey to #{stylist.email_address}"
        end
      end
    end
  end

  task :locations_test => :environment do 
    response = send_survey('adam@solasalonstudios.com', 3846)

    p "response=#{response}"
  end

  def send_survey(email, survey_id)
    `curl -i -H 'Accept: application/vnd.customersure.v1+json;' \
        -H 'Authorization: Token token="#{ENV['CUSTOMER_SURE_API_KEY']}"' \
        -H 'Content-Type: application/json' \
        -X POST \
        -d '{
              "email":"#{email}",
              "send_at":"#{DateTime.now.to_s}",
              "survey_id":#{survey_id}
            }' \
       https://api.customersure.com/feedback_requests`
  end

end