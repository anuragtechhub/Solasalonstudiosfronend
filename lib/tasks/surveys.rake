namespace :surveys do

  task :locations => :environment do

  end

  task :locations_test => :environment do 
    email = 'jeff@jeffbail.com'
    survey_id = 3846

    response = send_survey('jeff@jeffbail.com', 3846)

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