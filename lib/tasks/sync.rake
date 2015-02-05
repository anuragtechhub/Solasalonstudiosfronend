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
      location.status = meta['status']
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
      begin
        location.image_1 = open(get_img_src row['field_id_234']) unless row['field_id_234'].blank?
      rescue => e
        p "image 1 error = #{e.inspect}"
      end

      p "image 2"
      begin
      location.image_2 = open(get_img_src row['field_id_235']) unless row['field_id_235'].blank?
      rescue => e
        p "image 2 error = #{e.inspect}"
      end

      p "image 3"
      begin
      location.image_3 = open(get_img_src row['field_id_236']) unless row['field_id_236'].blank?
      rescue => e
        p "image 3 error = #{e.inspect}"
      end

      p "image 4"
      begin
      location.image_4 = open(get_img_src row['field_id_237']) unless row['field_id_237'].blank?
      rescue => e
        p "image 4 error = #{e.inspect}"
      end

      p "image 5"
      begin
      location.image_5 = open(get_img_src row['field_id_238']) unless row['field_id_238'].blank?
      rescue => e
        p "image 5 error = #{e.inspect}"
      end

      p "image 6"
      begin
      location.image_6 = open(get_img_src row['field_id_239']) unless row['field_id_239'].blank?
      rescue => e
        p "image 6 error = #{e.inspect}"
      end

      p "image 7"
      begin
      location.image_7 = open(get_img_src row['field_id_240']) unless row['field_id_240'].blank?
      rescue => e
        p "image 7 error = #{e.inspect}"
      end

      p "image 8"
      begin
      location.image_8 = open(get_img_src row['field_id_241']) unless row['field_id_241'].blank?
      rescue => e
        p "image 8 error = #{e.inspect}"
      end

      p "image 9"
      begin
      location.image_9 = open(get_img_src row['field_id_242']) unless row['field_id_242'].blank?
      rescue => e
        p "image 9 error = #{e.inspect}"
      end

      p "image 10"
      begin
      location.image_10 = open(get_img_src row['field_id_243']) unless row['field_id_243'].blank?
      rescue => e
        p "image 10 error = #{e.inspect}"
      end

      p "image 11"
      begin
      location.image_11 = open(get_img_src row['field_id_244']) unless row['field_id_244'].blank?
      rescue => e
        p "image 11 error = #{e.inspect}"
      end

      p "image 12"
      begin
      location.image_12 = open(get_img_src row['field_id_245']) unless row['field_id_245'].blank?
      rescue => e
        p "image 12 error = #{e.inspect}"
      end

      p "image 13"
      begin
      location.image_13 = open(get_img_src row['field_id_246']) unless row['field_id_246'].blank?
      rescue => e
        p "image 13 error = #{e.inspect}"
      end

      p "image 14"
      begin
      location.image_14 = open(get_img_src row['field_id_247']) unless row['field_id_247'].blank?
      rescue => e
        p "image 14 error = #{e.inspect}"
      end

      p "image 15"
      begin
      location.image_15 = open(get_img_src row['field_id_248']) unless row['field_id_248'].blank?
      rescue => e
        p "image 15 error = #{e.inspect}"
      end

      p "image 16"
      begin
      location.image_16 = open(get_img_src row['field_id_249']) unless row['field_id_249'].blank?
      rescue => e
        p "image 16 error = #{e.inspect}"
      end

      p "image 17"
      begin
      location.image_17 = open(get_img_src row['field_id_250']) unless row['field_id_250'].blank?
      rescue => e
        p "image 17 error = #{e.inspect}"
      end

      p "image 18"
      begin
      location.image_18 = open(get_img_src row['field_id_251']) unless row['field_id_251'].blank?
      rescue => e
        p "image 18 error = #{e.inspect}"
      end

      p "image 19"
      begin
      location.image_19 = open(get_img_src row['field_id_252']) unless row['field_id_252'].blank?
      rescue => e
        p "image 19 error = #{e.inspect}"
      end
      location.image_20 = nil

      p "floorplan image"
      begin
        location.floorplan_image = open(get_img_src row['field_id_308']) unless row['field_id_308'].blank?
      rescue => e
        p "image floorplan image error = #{e.inspect}"
      end

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
    results = db.query("SELECT * FROM exp_weblog_data WHERE weblog_id = 6")
    p "results.size = #{results.size}"
    results.each do |row|
      p "Processing (#{row['entry_id']})..."

      meta = db.query("SELECT * FROM exp_weblog_titles WHERE entry_id = #{row['entry_id']} LIMIT 1").first

      stylist = Stylist.find_by(:legacy_id => row['entry_id'].to_s) || Stylist.new
      
      stylist.legacy_id = row['entry_id']
      stylist.status = meta['status']
      stylist.name = meta['title']
      stylist.url_name = meta['url_title']

      p "stylist=#{stylist.inspect}"
      break
    end
  end

  def get_database_client
    Mysql2::Client.new(:host => 'solasalonstudios.com', :port => 3306, :database => 'sola_expressengine', :username => 'sola_stylist', :password => 'lostinthedream2014', :local_infile => false, :secure_auth => false)
  end

  def get_img_src(html)
    html.gsub!(/\{filedir_1\}/, 'http://www.solasalonstudios.com/images/uploads/')
    html.gsub!(/\{filedir_2\}/, 'http://www.solasalonstudios.com/images/uploads/assets/')
    html.gsub!(/\{filedir_3\}/, 'http://www.solasalonstudios.com/images/uploads/stylist_photos/')
    html.gsub!(/\{filedir_4\}/, 'http://www.solasalonstudios.com/images/uploads/store_photos/')

    Nokogiri::HTML(html).xpath('//img/@src').to_s
  end

end