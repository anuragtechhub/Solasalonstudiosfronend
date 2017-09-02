namespace :rentmanager do

  require 'rest-client'

  task :locations => :environment do
    p "Start Rent Manager locations task..."

    response = RestClient::Request.execute method: :get, url: 'https://solasalon.apiservices.rentmanager.com/api/locations', user: 'solapro', password: '20FCEF93-AD4D-4C7D-9B78-BA2492098481'
    p "response=#{response.inspect}"
    
    p "Finish Rent Manager locations task..."
  end

  task :properties => :environment do
    p "Start Rent Manager properties task..."

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