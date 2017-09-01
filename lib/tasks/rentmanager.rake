namespace :rentmanager do

  require 'rest-client'

  task :properties => :environment do
    p "Start Rent Manager properties task..."

    # solapro/CD992433-F6D3-4855-9829-DA3C46424F11
    # https://solasalon.apiservices.rentmanager.com/api/170/tenants

    #response = RestClient.get(, headers={})
    response = RestClient::Request.execute method: :get, url: 'https://solasalon.apiservices.rentmanager.com/api/170/tenants', user: 'solapro', password: '20FCEF93-AD4D-4C7D-9B78-BA2492098481'
    p "response=#{response.inspect}"
    
    p "Finish Rent Manager properties task..."
  end

  task :tenants => :environment do
    p "Start Rent Manager tenants task..."



    p "Finish Rent Manager tenants task..."
  end

  task :studios => :environment do
    p "Start Rent Manager studios task..."



    p "Finish Rent Manager studios task..."
  end  

end