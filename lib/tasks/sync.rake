namespace :sync do

  task :all => :environment do
    Rake::Task["sync:locations"].execute
    Rake::Task["sync:stylists"].execute
    Rake::Task["sync:blogs"].execute
    Rake::Task["sync:articles"].execute
  end

  task :stylists1 => :environment do
    sync_stylists(0)
  end            

  task :stylists2 => :environment do
    sync_stylists(500)
  end   

  task :stylists3 => :environment do
    sync_stylists(1000)
  end   

  task :stylists4 => :environment do
    sync_stylists(1500)
  end     

  task :stylists5 => :environment do
    sync_stylists(2000)
  end   

  task :stylists6 => :environment do
    sync_stylists(2500)
  end     

  task :stylists7 => :environment do
    sync_stylists(3000)
  end   

  task :stylists8 => :environment do
    sync_stylists(3500)
  end   

  task :stylists9 => :environment do
    sync_stylists(4000)
  end    

  task :stylists10 => :environment do
    sync_stylists(4500)
  end      

  task :stylists11 => :environment do
    sync_stylists(5000)
  end     

  task :stylists12 => :environment do
    sync_stylists(5500)
  end   

  task :stylists13 => :environment do
    sync_stylists(6000)
  end   

  task :stylists14 => :environment do
    sync_stylists(6500)
  end     

  task :stylists15 => :environment do
    sync_stylists(7000)
  end   

  task :stylists => :environment do
    (1..15).each do |num|
      Rake::Task["sync:stylists#{num}"].execute
    end
  end

  task :articles => :environment do
    p 'sync articles!'
    db = get_database_client
    results = db.query("SELECT * FROM exp_weblog_data WHERE weblog_id = 2")
    p "results.size = #{results.size}"
    count = results.size
    results.each_with_index do |row, idx|
      p "Processing (#{row['entry_id']}) #{idx + 1} of #{count}..."

      meta = db.query("SELECT * FROM exp_weblog_titles WHERE entry_id = #{row['entry_id']} LIMIT 1").first

      article = Article.find_by(:legacy_id => row['entry_id'].to_s) || Article.new

      article.legacy_id = row['entry_id']
      article.title = meta['title'].encode('UTF-8')
      article.url_title = meta['url_title'].encode('UTF-8')

      article.summary = filedir_replacement row['field_id_1'].encode('UTF-8')
      article.body = filedir_replacement row['field_id_2'].encode('UTF-8')
      article.extended_text = filedir_replacement row['field_id_3'].encode('UTF-8')

      p "image #{get_img_src row['field_id_12']}"
      begin
        article.image = open(get_img_src row['field_id_12']) unless row['field_id_12'].blank?
      rescue => e
        p "image error = #{e.inspect}"
      end

      if article.save
        p "Saved (#{row['entry_id']})!"
      else 
        p "ERROR saving (#{row['entry_id']}) - #{article.errors.inspect}"
      end
    end
  end

  task :blogs => :environment do
    p 'sync blogs!'
    db = get_database_client
    results = db.query("SELECT * FROM exp_weblog_data WHERE weblog_id = 18")
    p "results.size = #{results.size}"
    count = results.size
    results.each_with_index do |row, idx|
      p "Processing (#{row['entry_id']}) #{idx + 1} of #{count}..."

      meta = db.query("SELECT * FROM exp_weblog_titles WHERE entry_id = #{row['entry_id']} LIMIT 1").first

      blog = Blog.find_by(:legacy_id => row['entry_id'].to_s) || Blog.new

      blog.legacy_id = row['entry_id']
      blog.title = meta['title'].encode('UTF-8')
      blog.url_title = meta['url_title'].encode('UTF-8')
      blog.summary = filedir_replacement(row['field_id_202']).encode('UTF-8')
      blog.body = filedir_replacement(row['field_id_203']).encode('UTF-8')
      blog.author = row['field_id_252'].encode('UTF-8')
      
      p "image #{filedir_replacement row['field_id_201']}"
      begin
        blog.image = open(filedir_replacement row['field_id_201']) unless row['field_id_201'].blank?
      rescue => e
        p "image error = #{e.inspect}"
      end

      if blog.save
        p "Saved (#{row['entry_id']})!"
      else 
        p "ERROR saving (#{row['entry_id']}) - #{blog.errors.inspect}"
      end
    end
  end

  task :locations => :environment do
    p 'sync locations!'
    db = get_database_client
    results = db.query("SELECT * FROM exp_weblog_data WHERE weblog_id = 5")
    p "results.size = #{results.size}"
    count = results.size
    results.each_with_index do |row, idx|
      p "Processing (#{row['entry_id']}) #{idx + 1} of #{count}..."

      meta = db.query("SELECT * FROM exp_weblog_titles WHERE entry_id = #{row['entry_id']} LIMIT 1").first

      location = Location.find_by(:legacy_id => row['entry_id'].to_s) || Location.new
      
      location.legacy_id = row['entry_id']
      location.status = meta['status']
      location.name = meta['title'].encode('UTF-8')
      location.url_name = meta['url_title'].encode('UTF-8')
      location.description = row['field_id_19'].strip.encode('UTF-8')

      location.city = row['field_id_15'].encode('UTF-8')
      location.state = row['field_id_18'].encode('UTF-8')
      location.address_1 = row['field_id_16'].encode('UTF-8')
      location.postal_code = row['field_id_23'].encode('UTF-8')
      location.chat_code = row['field_id_304'].encode('UTF-8')
      
      location.email_address_for_inquiries = row['field_id_33'].encode('UTF-8')
      location.general_contact_name = row['field_id_34'].encode('UTF-8')
      location.phone_number = row['field_id_32'].encode('UTF-8')

      location.facebook_url = row['field_id_221'].encode('UTF-8')
      location.twitter_url = row['field_id_222'].encode('UTF-8')

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

  def sync_stylists(offset)
    p 'sync stylists!'
    db = get_database_client
    p "mysql db = #{db}"
    results = db.query("SELECT * FROM exp_weblog_data WHERE weblog_id = 6 LIMIT 500 OFFSET #{offset}")
    p "results.size = #{results.size}"
    count = results.size
    results.each_with_index do |row, idx|
      p "Processing (#{row['entry_id']}) #{idx + 1} of #{count}..."

      meta = db.query("SELECT * FROM exp_weblog_titles WHERE entry_id = #{row['entry_id']} LIMIT 1").first
      p "meta #{meta}"

      stylist = Stylist.find_by(:legacy_id => row['entry_id'].to_s) || Stylist.new

      p "gotta stylist"
      
      stylist.legacy_id = row['entry_id']
      stylist.status = meta['status']
      stylist.name = meta['title'].encode('UTF-8')
      stylist.url_name = meta['url_title'].encode('UTF-8')

      p "thru url name"

      stylist.biography = row['field_id_8'].strip.encode('UTF-8')
      stylist.email_address = row['field_id_9'].encode('UTF-8')
      stylist.phone_number = row['field_id_10'].encode('UTF-8')

      p "thru phone number"

      location_row = db.query("SELECT * FROM exp_categories WHERE cat_id IN (SELECT cat_id FROM exp_category_posts WHERE entry_id = #{row['entry_id']}) AND parent_id = 120 LIMIT 1").first
      if location_row 
        location = Location.find_by :url_name => location_row['cat_url_title']
        if location
          p "*"
          p "*"
          p "*"
          p "we have a location #{location_row['cat_url_title']}!"
          p "*"
          p "*"
          p "*"          
          stylist.location = location
        end
      end

      stylist.accepting_new_clients = row['field_id_31'] == 'No' ? false : true
      stylist.studio_number = row['field_id_11'].encode('UTF-8')
      stylist.work_hours = row['field_id_13'].encode('UTF-8')
      stylist.website = row['field_id_14'].encode('UTF-8')
      stylist.business_name = row['field_id_29'].encode('UTF-8')
      stylist.booking_url = row['field_id_220'].encode('UTF-8')

      p "thru booking url"

      stylist.hair = row['field_id_25']
      stylist.skin = row['field_id_27']
      stylist.nails = row['field_id_26']
      stylist.massage = row['field_id_28']
      stylist.teeth_whitening = row['field_id_36']
      stylist.hair_extensions = row['field_id_314']
      stylist.eyelash_extensions = row['field_id_198']
      stylist.makeup = row['field_id_219']
      stylist.tanning = row['field_id_303']
      stylist.waxing = row['field_id_305']
      stylist.brows = row['field_id_307']

      p "thru services"

      p "image 1"
      begin
        stylist.image_1 = open(get_img_src row['field_id_7']) unless row['field_id_7'].blank?
      rescue => e
        p "image 1 error = #{e.inspect}"
      end

      p "image 2"
      begin
        stylist.image_2 = open(get_img_src row['field_id_225']) unless row['field_id_225'].blank?
      rescue => e
        p "image 2 error = #{e.inspect}"
      end

      p "image 3"
      begin
        stylist.image_3 = open(get_img_src row['field_id_226']) unless row['field_id_226'].blank?
      rescue => e
        p "image 3 error = #{e.inspect}"
      end

      p "image 4"
      begin
        stylist.image_4 = open(get_img_src row['field_id_227']) unless row['field_id_227'].blank?
      rescue => e
        p "image 4 error = #{e.inspect}"
      end

      p "image 5"
      begin
        stylist.image_5 = open(get_img_src row['field_id_228']) unless row['field_id_228'].blank?
      rescue => e
        p "image 5 error = #{e.inspect}"
      end      

      p "image 6"
      begin
        stylist.image_6 = open(get_img_src row['field_id_229']) unless row['field_id_229'].blank?
      rescue => e
        p "image 6 error = #{e.inspect}"
      end 

      p "image 7"
      begin
        stylist.image_7 = open(get_img_src row['field_id_230']) unless row['field_id_230'].blank?
      rescue => e
        p "image 7 error = #{e.inspect}"
      end 

      p "image 8"
      begin
        stylist.image_8 = open(get_img_src row['field_id_231']) unless row['field_id_231'].blank?
      rescue => e
        p "image 8 error = #{e.inspect}"
      end 

      p "image 9"
      begin
        stylist.image_9 = open(get_img_src row['field_id_232']) unless row['field_id_232'].blank?
      rescue => e
        p "image 9 error = #{e.inspect}"
      end 

      p "image 10"
      begin
        stylist.image_10 = open(get_img_src row['field_id_233']) unless row['field_id_233'].blank?
      rescue => e
        p "image 10 error = #{e.inspect}"
      end       

      p "thru images"

      # testimonials

      if row['field_id_273'].present?
        stylist.testimonial_1 = Testimonial.new(:text => row['field_id_273'].encode('UTF-8'), :name => row['field_id_274'].encode('UTF-8'), :region => row['field_id_275'].encode('UTF-8'))
      end

      if row['field_id_276'].present?
        stylist.testimonial_1 = Testimonial.new(:text => row['field_id_276'].encode('UTF-8'), :name => row['field_id_277'].encode('UTF-8'), :region => row['field_id_278'].encode('UTF-8'))
      end

      if row['field_id_279'].present?
        stylist.testimonial_1 = Testimonial.new(:text => row['field_id_279'].encode('UTF-8'), :name => row['field_id_280'].encode('UTF-8'), :region => row['field_id_281'].encode('UTF-8'))
      end

      if row['field_id_282'].present?
        stylist.testimonial_1 = Testimonial.new(:text => row['field_id_282'].encode('UTF-8'), :name => row['field_id_283'].encode('UTF-8'), :region => row['field_id_284'].encode('UTF-8'))
      end

      if row['field_id_285'].present?
        stylist.testimonial_1 = Testimonial.new(:text => row['field_id_285'].encode('UTF-8'), :name => row['field_id_286'].encode('UTF-8'), :region => row['field_id_287'].encode('UTF-8'))
      end

      if row['field_id_288'].present?
        stylist.testimonial_1 = Testimonial.new(:text => row['field_id_288'].encode('UTF-8'), :name => row['field_id_289'].encode('UTF-8'), :region => row['field_id_290'].encode('UTF-8'))
      end

      if row['field_id_291'].present?
        stylist.testimonial_1 = Testimonial.new(:text => row['field_id_291'].encode('UTF-8'), :name => row['field_id_292'].encode('UTF-8'), :region => row['field_id_293'].encode('UTF-8'))
      end

      if row['field_id_294'].present?
        stylist.testimonial_1 = Testimonial.new(:text => row['field_id_294'].encode('UTF-8'), :name => row['field_id_295'].encode('UTF-8'), :region => row['field_id_296'].encode('UTF-8'))
      end

      if row['field_id_297'].present?
        stylist.testimonial_1 = Testimonial.new(:text => row['field_id_297'].encode('UTF-8'), :name => row['field_id_298'].encode('UTF-8'), :region => row['field_id_299'].encode('UTF-8'))
      end

      if row['field_id_300'].present?
        stylist.testimonial_1 = Testimonial.new(:text => row['field_id_300'].encode('UTF-8'), :name => row['field_id_301'].encode('UTF-8'), :region => row['field_id_302'].encode('UTF-8'))
      end

      p "thru testimonials"

      if stylist.save
        p "Saved #{row['entry_id']}!"
      else 
        p "ERROR saving #{row['entry_id']} - #{stylist.errors.inspect}"
      end
      #location. = row['field_id_']
    end
  end 

  def get_database_client
    Mysql2::Client.new(:host => 'solasalonstudios.com', :port => 3306, :database => 'sola_expressengine', :username => 'sola_stylist', :password => 'lostinthedream2014', :local_infile => false, :secure_auth => false)
  end

  def filedir_replacement(html)
    html.gsub!(/\{filedir_1\}/, 'http://www.solasalonstudios.com/images/uploads/')
    html.gsub!(/\{filedir_2\}/, 'http://www.solasalonstudios.com/images/uploads/assets/')
    html.gsub!(/\{filedir_3\}/, 'http://www.solasalonstudios.com/images/uploads/stylist_photos/')
    html.gsub!(/\{filedir_4\}/, 'http://www.solasalonstudios.com/images/uploads/store_photos/')

    html
  end

  def get_img_src(html)
    html = filedir_replacement(html)

    Nokogiri::HTML(html).xpath('//img/@src').to_s
  end

end