namespace :moz do

  # retrieves all submissions
  task :submissions => :environment do
    require 'net/https'
    require 'json'

    http = Net::HTTP.new('moz.com', 443)
    http.use_ssl = true

    http.start do |http|
      req = Net::HTTP::Get.new("/local/api/v1/submissions?access_token=JdoGE2CnK7Uj_w9hfkgQduHuKGWLsyGb")
      #req.set_form_data({'access_token' => 'JdoGE2CnK7Uj_w9hfkgQduHuKGWLsyGb'})
      resp = http.request(req)

      JSON.parse(resp.body).each do |entry|
        p "entry=#{entry.inspect}"
      end
    end
  end

end