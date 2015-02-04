namespace :sync do
  
  task :locations => :environment do
    p 'sync locations!'
    db = get_database_client
    p "mysql db = #{db}"
    results = db.query("SELECT * FROM exp_weblog_data WHERE weblog_id = 5")
    p "results.size = #{results.size}"
    results.each do |row|
      p "row=#{row['field_id_15']}"
      location = Location.find_by(:legacy_id => row['entry_id'].to_s) || Location.new
      p "location=#{location.new_record?}"
      
      location.city = row['field_id_15']
      location.state = row['field_id_18']
      location.address_1 = row['field_id_16']
      location.postal_code = row['field_id_23']
      location.description = row['field_id_19']
      
      location.email_address_for_inquiries = row['field_id_33']
      location.general_contact_name = row['field_id_34']
      location.phone_number = row['field_id_32']

      location.facebook_url = row['field_id_221']
      location.twitter_url = row['field_id_222']

      location.image_1 = open(get_img_src row['field_id_234']) if row['field_id_234']
      location.image_2 = open(get_img_src row['field_id_235']) if row['field_id_235']
      location.image_3 = open(get_img_src row['field_id_236']) if row['field_id_236']
      location.image_4 = open(get_img_src row['field_id_237']) if row['field_id_237']
      location.image_5 = open(get_img_src row['field_id_238']) if row['field_id_238']
      location.image_6 = open(get_img_src row['field_id_239']) if row['field_id_239']
      location.image_7 = open(get_img_src row['field_id_240']) if row['field_id_240']
      location.image_8 = open(get_img_src row['field_id_241']) if row['field_id_241']
      location.image_9 = open(get_img_src row['field_id_242']) if row['field_id_242']
      location.image_10 = open(get_img_src row['field_id_243']) if row['field_id_243']
      location.image_11 = open(get_img_src row['field_id_244']) if row['field_id_244']
      location.image_12 = open(get_img_src row['field_id_245']) if row['field_id_245']
      location.image_13 = open(get_img_src row['field_id_246']) if row['field_id_246']
      location.image_14 = open(get_img_src row['field_id_247']) if row['field_id_247']
      location.image_15 = open(get_img_src row['field_id_248']) if row['field_id_248']
      location.image_16 = open(get_img_src row['field_id_249']) if row['field_id_249']
      location.image_17 = open(get_img_src row['field_id_250']) if row['field_id_250']
      location.image_18 = open(get_img_src row['field_id_251']) if row['field_id_251']
      location.image_19 = open(get_img_src row['field_id_252']) if row['field_id_252']
      location.image_20 = nil

      #location. = open(get_img_src row['field_id_308']) {filedir_2}directory1.png 

      #location. = row['field_id_']
      break
    end
  end 

  def get_database_client
    Mysql2::Client.new(:host => 'solasalonstudios.com', :port => 3306, :database => 'sola_expressengine', :username => 'sola_stylist', :password => 'lostinthedream2014', :local_infile => false, :secure_auth => false)
  end

  def get_img_src(html)
    filedir_2 = 
    filedir_4 = 'http://www.solasalonstudios.com/images/uploads/store_photos/'

    html.gsub!(/\{filedir_2\}/, filedir_2)
    html.gsub!(/\{filedir_4\}/, filedir_4)

    Nokogiri::HTML(html).xpath('//img/@src').to_s
  end

end