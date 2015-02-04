namespace :sync do
  
  task :locations => :environment do
    p 'sync locations!'
    db = get_database_client
    results = db.query("SELECT * FROM exp_weblog_data WHERE weblog_id = 5")
    p "results.size = #{results.size}"
    results.each do |row|
      p "Processing #{row['field_id_15']} (#{row['entry_id']})..."

      meta = db.query("SELECT * FROM exp_weblog_titles WHERE entry_id = #{row['entry_id']} LIMIT 1").first

      location = Location.find_by(:legacy_id => row['entry_id'].to_s) || Location.new
      
      location.legacy_id = row['entry_id']
      location.name = meta['title']
      location.url_name = meta['url_title']
      location.description = row['field_id_19']

      location.city = row['field_id_15']
      location.state = row['field_id_18']
      location.address_1 = row['field_id_16']
      location.postal_code = row['field_id_23']
      
      
      location.email_address_for_inquiries = row['field_id_33']
      location.general_contact_name = row['field_id_34']
      location.phone_number = row['field_id_32']

      location.facebook_url = row['field_id_221']
      location.twitter_url = row['field_id_222']

      p "image 1"
      location.image_1 = open(get_img_src row['field_id_234']) unless row['field_id_234'].blank?
      p "image 2"
      location.image_2 = open(get_img_src row['field_id_235']) unless row['field_id_235'].blank?
      p "image 3"
      location.image_3 = open(get_img_src row['field_id_236']) unless row['field_id_236'].blank?
      p "image 4"
      location.image_4 = open(get_img_src row['field_id_237']) unless row['field_id_237'].blank?
      p "image 5"
      location.image_5 = open(get_img_src row['field_id_238']) unless row['field_id_238'].blank?
      p "image 6"
      location.image_6 = open(get_img_src row['field_id_239']) unless row['field_id_239'].blank?
      p "image 7"
      location.image_7 = open(get_img_src row['field_id_240']) unless row['field_id_240'].blank?
      p "image 8"
      location.image_8 = open(get_img_src row['field_id_241']) unless row['field_id_241'].blank?
      p "image 9"
      location.image_9 = open(get_img_src row['field_id_242']) unless row['field_id_242'].blank?
      p "image 10"
      location.image_10 = open(get_img_src row['field_id_243']) unless row['field_id_243'].blank?
      p "image 11"
      location.image_11 = open(get_img_src row['field_id_244']) unless row['field_id_244'].blank?
      p "image 12"
      location.image_12 = open(get_img_src row['field_id_245']) unless row['field_id_245'].blank?
      p "image 13"
      location.image_13 = open(get_img_src row['field_id_246']) unless row['field_id_246'].blank?
      p "image 14"
      location.image_14 = open(get_img_src row['field_id_247']) unless row['field_id_247'].blank?
      p "image 15"
      location.image_15 = open(get_img_src row['field_id_248']) unless row['field_id_248'].blank?
      p "image 16"
      location.image_16 = open(get_img_src row['field_id_249']) unless row['field_id_249'].blank?
      p "image 17"
      location.image_17 = open(get_img_src row['field_id_250']) unless row['field_id_250'].blank?
      p "image 18"
      location.image_18 = open(get_img_src row['field_id_251']) unless row['field_id_251'].blank?
      p "image 19"
      location.image_19 = open(get_img_src row['field_id_252']) unless row['field_id_252'].blank?
      location.image_20 = nil

      p "floorplan image"
      location.floorplan_image = open(get_img_src row['field_id_308']) unless row['field_id_308'].blank?

      #location. = row['field_id_']
      if location.save
        p "Saved #{row['field_id_15']} (#{row['entry_id']})!"
      else 
        p "ERROR saving #{row['field_id_15']} (#{row['entry_id']}) - #{location.errors.inspect}"
      end
    end
  end 

  task :stylists => :environment do
    p 'sync stylists!'
    db = get_database_client
    p "mysql db = #{db}"
    results = db.query("SELECT * FROM exp_weblog_data WHERE weblog_id = 5")
    p "results.size = #{results.size}"
    results.each do |row|
      p "Processing #{row['field_id_15']} (#{row['entry_id']})..."

      meta = db.query("SELECT * FROM exp_weblog_titles WHERE entry_id = #{row['entry_id']} LIMIT 1").first
  end

  def get_database_client
    Mysql2::Client.new(:host => 'solasalonstudios.com', :port => 3306, :database => 'sola_expressengine', :username => 'sola_stylist', :password => 'lostinthedream2014', :local_infile => false, :secure_auth => false)
  end

  def get_img_src(html)
    filedir_2 = 'http://www.solasalonstudios.com/images/uploads/assets/'
    filedir_4 = 'http://www.solasalonstudios.com/images/uploads/store_photos/'

    html.gsub!(/\{filedir_2\}/, filedir_2)
    html.gsub!(/\{filedir_4\}/, filedir_4)

    Nokogiri::HTML(html).xpath('//img/@src').to_s
  end

end