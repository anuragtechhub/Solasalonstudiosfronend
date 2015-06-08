namespace :sync do

  task :all => :environment do
    Rake::Task["sync:locations"].execute
    Rake::Task["sync:stylists"].execute
    Rake::Task["sync:blogs"].execute
    Rake::Task["sync:articles"].execute
  end

  task :locfix, [:legacy_id, :cat_id] => :environment do |task, args|
    location = Location.find_by :legacy_id => args.legacy_id
    p "Location fix in progress for #{location.name}"

    db = get_database_client
    results = db.query("SELECT * FROM exp_weblog_data WHERE weblog_id = 6 AND entry_id IN (SELECT entry_id FROM exp_category_posts WHERE cat_id = #{args.cat_id})");
    p "There are #{results.size} results for this location"

    results.each do |row|
      stylist = Stylist.find_by :legacy_id => row['entry_id'].to_s
      if stylist
        p "Found stylist #{stylist.name}, #{stylist.location.name if stylist.location}"
        stylist.location = location
        stylist.save
      else
        p "No stylist found with legacy_id of #{row['entry_id']}"
      end
    end
  end

  task :locationsfix => :environment do

    locations = [
      ["8410", 423], #kirkwood
      ["6830", 338], #creve
      ["5166", 271] #st james
   #  ["4171", 208], 
   #  ["7564", 401], 
   #  ["4568", 226], 
   #  ["5509", 313], 
   #  ["5510", 314], 		
   #  ["7519", 397],
 		# ["542", 37],
 		# ["2207", 96],
 		# ["4941", 257],
 		# ["93", 7],
 		# ["618", 48],
 		# ["9133", 444],
 		# ["5166", 271],
 		# ["5832", 276],
 		# ["6335", 360],
 		# ["6574", 364],
 		# ["1363", 79],
 		# ["7310", 393],
 		# ["6378", 362],
 		# ["6578", 365],
 		# ["3691", 171],
 		# ["5862", 335],
 		# ["5868", 336],
 		# ["9042", 441],
 		# ["8558", 425],
 		# ["8573", 427],
 		# ["600", 66],
 		# ["9214", 448],
 		# ["1186", 73],
 		# ["1843", 86],
 		# ["8009", 418],
 		# ["4759", 245],
 		# ["5208", 279],
 		# ["5278", 293],
 		# ["5934", 343],
 		# ["9841", 413],
 		# ["9974", 475],
 		# ["9902", 469],
 		# ["9903", 470],
 		# ["9907", 471],
 		# ["5261", 288],
 		# ["94", 149],
 		# ["4809", 248],
 		# ["4928", 260],
 		# ["6830", 338],
 		# ["1891", 170],
 		# ["569", 43],
 		# ["5523", 307],
 		# ["1235", 76],
 		# ["695", 52],
 		# ["2313", 99],
 		# ["2806", 103],
 		# ["8295", 422],
 		# ["5275", 291],
 		# ["460", 34],
 		# ["8754", 435],
 		# ["923", 64],
 		# ["5296", 294],
 		# ["5297", 295],
 		# ["8955", 436],
 		# ["1059", 74],
 		# ["6172", 358],
 		# ["2759", 105],
 		# ["9017", 437],
 		# ["9906", 472],
 		# ["5936", 344],
 		# ["6010", 346],
 		# ["6800", 372],
 		# ["6776", 371],
 		# ["4758", 242],
 		# ["936", 45],
 		# ["4933", 256],
 		# ["997", 39],
 		# ["1056", 69],
 		# ["2952", 113],
 		# ["3330", 163],
 		# ["3588", 167],
 		# ["733", 55],
 		# ["2965", 58],
 		# ["21", 6],
 		# ["6746", 340],
 		# ["7524", 398],
 		# ["7668", 403],
 		# ["8114", 419],
 		# ["9026", 466],
 		# ["1562", 83],
 		# ["7326", 394],
 		# ["7327", 395],
 		# ["8058", 417],
 		# ["2087", 92],
 		# ["6762", 370],
 		# ["677", 51],
 		# ["2086", 91],
 		# ["9041", 440],
 		# ["723", 54],
 		# ["6825", 373],
 		# ["6578", 365],
 		# ["1057", 70],
 		# ["7834", 410],
 		# ["2108", 94],
 		# ["2398", 101],
 		# ["7161", 387],
 		# ["9275", 455],
 		# ["2869", 108],
 		# ["9390", 460],
 		# ["9421", 462],
 		# ["9654", 465],
 		# ["2812", 106],
 		# ["9213", 447],
 		# ["22", 4],
 		# ["1946", 89],
 		# ["9353", 457],
 		# ["130", 16],
 		# ["2953", 112],
 		# ["3172", 152],
 		# ["1361", 78],
 		# ["2708", 98],
 		# ["7032", 383],
 		# ["4693", 235],
 		# ["3191", 154],
 		# ["1369", 81],
 		# ["4627", 231],
 		# ["3219", 156],
 		# ["5009", 262],
 		# ["6847", 375],
 		# ["1734", 85],
 		# ["7895", 413],
 		# ["5396", 305],
 		# ["5548", 316],
 		# ["867", 62],
 		# ["5074", 284],
 		# ["3907", 200],
 		# ["4252", 213],
 		# ["4627", 231],
 		# ["4622", 229],
 		# ["3236", 158],
 		# ["4729", 239],
 		# ["5066", 265],
 		# ["1015", 68],
 		# ["3189", 111],
 		# ["3190", 155],
 		# ["4882", 231],
 		# ["145", 24],
 		# ["4925", 263],
 		# ["4170", 207],
 		# ["2867", 107],
 		# ["3081", 146],
 		# ["5266", 287],
 		# ["6981", 380],
 		# ["3220", 157],
 		# ["735", 57],
 		# ["6913", 376],
 		# ["4874", 251],
 		# ["148", 27],
 		# ["3303", 119],
 		# ["5685", 325],
 		# ["4694", 234],
 		# ["5082", 266],
 		# ["4696", 236],
 		# ["5505", 311],
 		# ["5084", 268],
 		# ["4329", 216],
 		# ["5507", 312],
 		# ["6061", 348],
 		# ["6579", 365],
 		# ["3301", 162],
 		# ["5617", 321],
 		# ["5808", 332],
 		# ["5173", 273],
 		# ["5215", 281],
 		# ["6136", 356],
 		# ["3322", 166],
 		# ["7200", 390],
 		# ["7537", 399],
 		# ["9266", 454],
 		# ["5217", 282],
 		# ["5807", 331],
 		# ["7778", 408],
 		# ["6473", 363],
 		# ["5375", 342],
 		# ["6581", 367],
 		# ["270", 30],
 		# ["7978", 416],
 		# ["5083", 267],
 		# ["4066", 203],
 		# ["4722", 238],
 		# ["5632", 322],
 		# ["4364", 218],
 		# ["4763", 246],
 		# ["4487", 220],
 		# ["3043", 118],
 		# ["6989", 382],
 		# ["6992", 355],
 		# ["9250", 451],
 		# ["5514", 317],
 		# ["258", 31],
 		# ["5686", 324],
 		# ["4259", 214],
 		# ["7977", 415],
 		# ["6173", 359],
 		# ["9354", 458],
 		# ["8707", 431],
 		# ["9018", 438],
 		# ["4330", 217],
 		# ["871", 65],
 		# ["8733", 433],
 		# ["5180", 278],
 		# ["7872", 411],
 		# ["6334", 361],
 		# ["3267", 159],
 		# ["5412", 308],
 		# ["1607", 84],
 		# ["5697", 327],
 		# ["2071", 90],
 		# ["609", 47],
 		# ["5226", 285],
 		# ["9262", 452],
 		# ["8410", 423],
 		# ["8732", 432],
 		# ["146", 26],
 		# ["865", 61],
 		# ["20", 5],
 		# ["5362", 297],
 		# ["5737", 328],
 		# ["7075", 385],
 		# ["7201", 391],
 		# ["2458", 104],
 		# ["197", 29],
 		# ["399", 32],
 		# ["456", 33],
 		# ["838", 60],
 		# ["4223", 212],
 		# ["2187", 95],
 		# ["1155", 72],
 		# ["8574", 429],
 		# ["1103", 71],
 		# ["475", 147],
 		# ["6960", 379],
 		# ["6961", 378],
 		# ["5738", 329],
 		# ["581", 44],
 		# ["2114", 93],
 		# ["3674", 169],
 		# ["4545", 224],
 		# ["4390", 219],
 		# ["4569", 228],
 		# ["3673", 168],
 		# ["7690", 405],
 		# ["7779", 409],
 		# ["2884", 109],
 		# ["4936", 255],
 		# ["3562", 153],
 		# ["4956", 259],
 		# ["4540", 222],
 		# ["6069", 351],
 		# ["6082", 352],
 		# ["6110", 354],
 		# ["635", 49],
   #  ["2885", 110]
  ]
    locations.each do |loc|
      p "loc[0]=#{loc[0]}"
      location = Location.find_by :legacy_id => loc[0]
      p "Location fix in progress for #{location.name}"

      db = get_database_client
      results = db.query("SELECT * FROM exp_weblog_data WHERE weblog_id = 6 AND entry_id IN (SELECT entry_id FROM exp_category_posts WHERE cat_id = #{loc[1]})");
      p "There are #{results.size} results for this location"

      results.each do |row|
        stylist = Stylist.find_by :legacy_id => row['entry_id'].to_s
        if stylist
          p "Found stylist #{stylist.name}, #{stylist.location.name if stylist.location}"
          stylist.location = location
          stylist.save
        else
          p "No stylist found with legacy_id of #{row['entry_id']}"
        end
      end
    end

  end

  # task :imgfix => :environment do
  #   Blog.all.each do |blog|

  #     blog.body = blog.body.gsub(/<img[^>]+\>/) { |img|
  #       p "img=#{img}"
  #       matches = /src="([^"]+)"/.match(img)

  #       if matches && matches.size > 0
  #         src = matches[1].gsub(/www.solasalonstudios.com/, '69.73.148.8')
  #         #p "src=#{src}"
  #         #p "open=#{open(src)}"
          
  #         obj = S3_BUCKET.objects[src]
  #         obj.write(file: open(src), acl: :public_read)
  #         p "obj.public_url=#{obj.public_url}"
  #         "<img src=\"#{obj.public_url}\">"
  #       end
  #     }
  #     p ""
  #     p "blog.body=#{blog.body}"
  #     if blog.save
  #       p "blog saved! #{blog.url_name}"
  #     else
  #       p "ERROR saving #{blog.errors.inspect}"
  #     end
  #   end
  #   Article.all.each do |article|

  #     article.body = article.body.gsub(/<img[^>]+\>/) { |img|
  #       p "img=#{img}"
  #       matches = /src="([^"]+)"/.match(img)

  #       if matches && matches.size > 0
  #         src = matches[1].gsub(/www.solasalonstudios.com/, '69.73.148.8')
  #         #p "src=#{src}"
  #         #p "open=#{open(src)}"
          
  #         obj = S3_BUCKET.objects[src]
  #         obj.write(file: open(src), acl: :public_read)
  #         p "obj.public_url=#{obj.public_url}"
  #         "<img src=\"#{obj.public_url}\">"
  #       end
  #     }
  #     p ""
  #     p "article.body=#{article.body}"
  #     if article.save
  #       p "article saved! #{article.url_name}"
  #     else
  #       p "ERROR saving #{article.errors.inspect}"
  #     end
  #   end    
  # end

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

  task :stylists16 => :environment do
    sync_stylists(7500)
  end 

  task :stylists17 => :environment do
    sync_stylists(8000)
  end   

  task :stylists => :environment do
    (1..17).each do |num|
      Rake::Task["sync:stylists#{num}"].execute
    end
  end

  # task :franchisees => :environment do
  #   p 'sync franchisees!'
  #   db = get_database_client
  #   results = db.query("SELECT * FROM exp_members WHERE group_id = 7")
  #   p "results.size = #{results.size}"
  #   count = results.size
  #   results.each_with_index do |row, idx|
  #     p "Processing (#{row['member_id']}) #{idx + 1} of #{count}..."

  #     admin = Admin.find_by(:legacy_id => row['member_id'].to_s) || Admin.new
      
  #     admin.franchisee = true
  #     admin.legacy_id = row['member_id']
  #     admin.email = row['username']
  #     admin.email_address = row['email']
  #     admin.password = 'solastyle777'
  #     admin.password_confirmation = 'solastyle777'

  #     if admin.save
  #       p "Saved admin"
  #     else
  #       p "ERROR saving admin #{admin.errors.inspect}"
  #     end

  #     # save admin locations
  #     location_rows = db.query("SELECT * FROM exp_weblog_titles WHERE weblog_id = 5 AND author_id = #{admin.legacy_id}")
  #     p "admin locations = #{location_rows.size}"
  #     location_rows.each do |location_row|
  #       location = Location.find_by(:legacy_id => location_row['entry_id'].to_s)
  #       location.admin_id = admin.id if location && admin
  #       if location && location.save
  #         p "saved location for admin"
  #       else
  #         p "problem saving location #{location_row.inspect} | #{location.inspect}"
  #       end
  #     end
  #   end    
  # end

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
      
      article.created_at = Date.new(meta['year'].to_i, meta['month'].to_i, meta['day'].to_i)
      article.legacy_id = row['entry_id']
      article.title = meta['title'].encode('UTF-8')
      article.url_name = meta['url_title'].encode('UTF-8')

      article.summary = filedir_replacement row['field_id_1'].encode('UTF-8')
      article.body = filedir_replacement row['field_id_2'].encode('UTF-8')
      article.article_url = filedir_replacement row['field_id_3'].encode('UTF-8')
      
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

      blog.created_at = Date.new(meta['year'].to_i, meta['month'].to_i, meta['day'].to_i)
      blog.legacy_id = row['entry_id']
      blog.title = meta['title'].encode('UTF-8')
      blog.url_name = meta['url_title'].encode('UTF-8')
      blog.summary = filedir_replacement(row['field_id_202']).encode('UTF-8')
      blog.body = filedir_replacement(row['field_id_203']).encode('UTF-8')
      blog.author = row['field_id_252'].encode('UTF-8')
      
      p "image #{filedir_replacement row['field_id_201']}"
      begin
        blog.image = open(filedir_replacement row['field_id_201']) unless row['field_id_201'].blank?
      rescue => e
        p "image error = #{e.inspect}"
      end

      categories = db.query("SELECT cat_id FROM exp_category_posts WHERE entry_id = #{row['entry_id']}")
      if categories and categories.size > 0
        p "WE HAVE CATEGORIES #{categories}"
        categories.each do |category|
          p "category=#{category}"
          blog_category = db.query("SELECT * FROM exp_categories WHERE cat_id = #{category['cat_id']} LIMIT 1").first
          if blog_category and blog_category.size > 0
            category = BlogCategory.find_or_create_by(:url_name => blog_category['cat_url_title'])
            category.legacy_id = blog_category['cat_id'].to_s
            category.url_name = blog_category['cat_url_title']
            category.name = blog_category['cat_name']
            category.save
            
            blog.blog_categories << category
          end
        end
      else
        p "WE DO NOT HAVE ANY categories"
      end
      #


      if blog.save
        p "Saved (#{row['entry_id']})!"
      else 
        p "ERROR saving (#{row['entry_id']}) - #{blog.errors.inspect}"
      end
    end
  end

  task :msas => :environment do
    db = get_database_client
    Location.all.each do |location|
      if location.legacy_id && location.url_name
        #p 
        #p
        #p "SELECT * FROM exp_categories WHERE cat_id IN (SELECT cat_id FROM exp_category_posts WHERE entry_id = #{location.legacy_id}) ORDER BY parent_id DESC LIMIT 1"
        row = db.query("SELECT * FROM exp_categories WHERE cat_id IN (SELECT cat_id FROM exp_category_posts WHERE entry_id = #{location.legacy_id}) AND cat_url_title != '#{location.url_name}' AND parent_id != 0 ORDER BY parent_id ASC LIMIT 1").first
        #p "#{location.legacy_id}, #{location.name}, #{row.inspect}"
        if row && row.size > 0
          msa = Msa.find_by(:legacy_id => row['cat_id'].to_s) || Msa.new

          msa.legacy_id = row['cat_id']
          msa.name = row['cat_name']
          msa.url_name = row['cat_url_title']

          description = db.query("SELECT * FROM exp_weblog_data WHERE entry_id = (SELECT entry_id FROM exp_weblog_titles WHERE url_title = '#{row['cat_url_title']}' LIMIT 1) LIMIT 1").first
          if description
            p "DESCRIPTION = #{description['field_id_75']}"
            msa.description = description['field_id_75']
          else
            p "NO DESCRIPTION"
          end

          if msa.save
            p "MSA Saved!!!! #{location.legacy_id}, #{location.name}, #{msa.inspect}"
          else
            p "ERROR saving MSA #{msa.errors.inspect}"
          end

          location.msa = msa
          if location.save
            p "saved location"
          else
            p "error saving location #{location.errors.inspect}"
          end
        else
          p "NO ROW??? #{location.legacy_id}, #{location.name}"
        end
      end
    end
  end

  task :locations1 => :environment do
    sync_locations(0)
  end            

  task :locations2 => :environment do
    sync_locations(50)
  end   

  task :locations3 => :environment do
    sync_locations(100)
  end   

  task :locations4 => :environment do
    sync_locations(150)
  end 

  task :locations5 => :environment do
    sync_locations(200)
  end

  task :locations6 => :environment do
    sync_locations(250)
  end  

  task :locations7 => :environment do
    sync_locations(300)
  end  

  task :locations => :environment do
    (1..7).each do |num|
      Rake::Task["sync:locations#{num}"].execute
    end
  end

  def sync_locations(offset)
    p 'sync locations!'
    db = get_database_client
    results = db.query("SELECT * FROM exp_weblog_data WHERE weblog_id = 5 LIMIT 50 OFFSET #{offset}")
    p "results.size = #{results.size}"
    count = results.size
    results.each_with_index do |row, idx|
      p "Processing (#{row['entry_id']}) #{idx + 1} of #{count}..."

      meta = db.query("SELECT * FROM exp_weblog_titles WHERE entry_id = #{row['entry_id']} LIMIT 1").first

      location = Location.where(:status => 'open').find_by(:legacy_id => row['entry_id'].to_s) || Location.new
      
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
        location.image_1 = open(get_img_src row['field_id_20']) unless row['field_id_20'].blank?
      rescue => e
        p "image 1 error = #{e.inspect}"
      end

      p "image 2"
      begin
      location.image_2 = open(get_img_src row['field_id_21']) unless row['field_id_21'].blank?
      rescue => e
        p "image 2 error = #{e.inspect}"
      end

      p "image 3"
      begin
      location.image_3 = open(get_img_src row['field_id_234']) unless row['field_id_234'].blank?
      rescue => e
        p "image 3 error = #{e.inspect}"
      end

      p "image 4"
      begin
      location.image_4 = open(get_img_src row['field_id_235']) unless row['field_id_235'].blank?
      rescue => e
        p "image 4 error = #{e.inspect}"
      end

      p "image 5"
      begin
      location.image_5 = open(get_img_src row['field_id_236']) unless row['field_id_236'].blank?
      rescue => e
        p "image 5 error = #{e.inspect}"
      end

      p "image 6"
      begin
      location.image_6 = open(get_img_src row['field_id_237']) unless row['field_id_237'].blank?
      rescue => e
        p "image 6 error = #{e.inspect}"
      end

      p "image 7"
      begin
      location.image_7 = open(get_img_src row['field_id_238']) unless row['field_id_238'].blank?
      rescue => e
        p "image 7 error = #{e.inspect}"
      end

      p "image 8"
      begin
      location.image_8 = open(get_img_src row['field_id_239']) unless row['field_id_239'].blank?
      rescue => e
        p "image 8 error = #{e.inspect}"
      end

      p "image 9"
      begin
      location.image_9 = open(get_img_src row['field_id_240']) unless row['field_id_240'].blank?
      rescue => e
        p "image 9 error = #{e.inspect}"
      end

      p "image 10"
      begin
      location.image_10 = open(get_img_src row['field_id_241']) unless row['field_id_241'].blank?
      rescue => e
        p "image 10 error = #{e.inspect}"
      end

      p "image 11"
      begin
      location.image_11 = open(get_img_src row['field_id_242']) unless row['field_id_242'].blank?
      rescue => e
        p "image 11 error = #{e.inspect}"
      end

      p "image 12"
      begin
      location.image_12 = open(get_img_src row['field_id_243']) unless row['field_id_243'].blank?
      rescue => e
        p "image 12 error = #{e.inspect}"
      end

      p "image 13"
      begin
      location.image_13 = open(get_img_src row['field_id_244']) unless row['field_id_244'].blank?
      rescue => e
        p "image 13 error = #{e.inspect}"
      end

      p "image 14"
      begin
      location.image_14 = open(get_img_src row['field_id_245']) unless row['field_id_245'].blank?
      rescue => e
        p "image 14 error = #{e.inspect}"
      end

      p "image 15"
      begin
      location.image_15 = open(get_img_src row['field_id_246']) unless row['field_id_246'].blank?
      rescue => e
        p "image 15 error = #{e.inspect}"
      end

      p "image 16"
      begin
      location.image_16 = open(get_img_src row['field_id_247']) unless row['field_id_247'].blank?
      rescue => e
        p "image 16 error = #{e.inspect}"
      end

      p "image 17"
      begin
      location.image_17 = open(get_img_src row['field_id_248']) unless row['field_id_248'].blank?
      rescue => e
        p "image 17 error = #{e.inspect}"
      end

      p "image 18"
      begin
      location.image_18 = open(get_img_src row['field_id_249']) unless row['field_id_249'].blank?
      rescue => e
        p "image 18 error = #{e.inspect}"
      end

      p "image 19"
      begin
      location.image_19 = open(get_img_src row['field_id_250']) unless row['field_id_250'].blank?
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
      next if row['entry_id'] == 9613 || row['entry_id'] == 9614 || idx < 300
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

      msa_way = false
      location_row = db.query("SELECT * FROM exp_categories WHERE cat_id IN (SELECT cat_id FROM exp_category_posts WHERE entry_id = #{row['entry_id']}) ORDER BY parent_id DESC LIMIT 1").first
      if location_row 
        location = Location.where(:status => 'open').find_by(:name => location_row['cat_name']) || Location.where(:status => 'open').find_by(:url_name => location_row['cat_url_title'])
        if location
          p "*"
          p "*"
          p "*"
          p "we have a location #{location_row['cat_url_title']}!"
          p "*"
          p "*"
          p "*"          
          stylist.location = location
        else
          msa_way = true
        end
      else
        msa_way = true
      end

      if msa_way
        p "going MSA way..."
        msa_ids = db.query("SELECT cat_id FROM exp_category_posts WHERE entry_id = #{row['entry_id']} ORDER BY cat_id DESC")
        if msa_ids 
          #p "location_row = #{location_row.inspect}"
          p "msa_ids=#{msa_ids.inspect}"
          msa_ids.each do |msa_id|
            p "msa_id=#{msa_id}"
            msa = Msa.where(:legacy_id => msa_id['cat_id'].to_s)
            if msa && msa.size > 0
              location = Location.find_by(:msa_id => msa.first.id) #|| Location.find_by(:name => location_row['cat_name']) || Location.find_by(:url_name => location_row['cat_url_title'])
              p "location=#{location.inspect}"
              if location
                p "*"
                p "*"
                p "*"
                p "we have a location!"
                p "*"
                p "*"
                p "*"          
                stylist.location = location
                break;
              end
            end
          end
        end  
      end

      stylist.accepting_new_clients = row['field_id_31'] == 'No' ? false : true
      stylist.studio_number = row['field_id_11'].encode('UTF-8')
      stylist.work_hours = row['field_id_13'].encode('UTF-8')
      stylist.website_url = row['field_id_14'].encode('UTF-8')
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
        stylist.testimonial_2 = Testimonial.new(:text => row['field_id_276'].encode('UTF-8'), :name => row['field_id_277'].encode('UTF-8'), :region => row['field_id_278'].encode('UTF-8'))
      end

      if row['field_id_279'].present?
        stylist.testimonial_3 = Testimonial.new(:text => row['field_id_279'].encode('UTF-8'), :name => row['field_id_280'].encode('UTF-8'), :region => row['field_id_281'].encode('UTF-8'))
      end

      if row['field_id_282'].present?
        stylist.testimonial_4 = Testimonial.new(:text => row['field_id_282'].encode('UTF-8'), :name => row['field_id_283'].encode('UTF-8'), :region => row['field_id_284'].encode('UTF-8'))
      end

      if row['field_id_285'].present?
        stylist.testimonial_5 = Testimonial.new(:text => row['field_id_285'].encode('UTF-8'), :name => row['field_id_286'].encode('UTF-8'), :region => row['field_id_287'].encode('UTF-8'))
      end

      if row['field_id_288'].present?
        stylist.testimonial_6 = Testimonial.new(:text => row['field_id_288'].encode('UTF-8'), :name => row['field_id_289'].encode('UTF-8'), :region => row['field_id_290'].encode('UTF-8'))
      end

      if row['field_id_291'].present?
        stylist.testimonial_7 = Testimonial.new(:text => row['field_id_291'].encode('UTF-8'), :name => row['field_id_292'].encode('UTF-8'), :region => row['field_id_293'].encode('UTF-8'))
      end

      if row['field_id_294'].present?
        stylist.testimonial_8 = Testimonial.new(:text => row['field_id_294'].encode('UTF-8'), :name => row['field_id_295'].encode('UTF-8'), :region => row['field_id_296'].encode('UTF-8'))
      end

      if row['field_id_297'].present?
        stylist.testimonial_9 = Testimonial.new(:text => row['field_id_297'].encode('UTF-8'), :name => row['field_id_298'].encode('UTF-8'), :region => row['field_id_299'].encode('UTF-8'))
      end

      if row['field_id_300'].present?
        stylist.testimonial_10 = Testimonial.new(:text => row['field_id_300'].encode('UTF-8'), :name => row['field_id_301'].encode('UTF-8'), :region => row['field_id_302'].encode('UTF-8'))
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

  task :stylist => :environment do
    p 'sync stylists!'
    db = get_database_client
    p "mysql db = #{db}"
    results = db.query("SELECT * FROM exp_weblog_data WHERE weblog_id = 6 AND entry_id = 414")
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

      msa_ids = db.query("SELECT cat_id FROM exp_category_posts WHERE entry_id = #{row['entry_id']} ORDER BY cat_id DESC")
      if msa_ids 
        #p "location_row = #{location_row.inspect}"
        p "msa_ids=#{msa_ids.inspect}"
        msa_ids.each do |msa_id|
          p "msa_id=#{msa_id}"
          msa = Msa.where(:legacy_id => msa_id['cat_id'].to_s)
          if msa && msa.size > 0
            location = Location.find_by(:msa_id => msa.first.id) #|| Location.find_by(:name => location_row['cat_name']) || Location.find_by(:url_name => location_row['cat_url_title'])
            p "location=#{location.inspect}"
            if location
              p "*"
              p "*"
              p "*"
              p "we have a location!"
              p "*"
              p "*"
              p "*"          
              stylist.location = location
              break;
            end
          end
        end
      end

      stylist.accepting_new_clients = row['field_id_31'] == 'No' ? false : true
      stylist.studio_number = row['field_id_11'].encode('UTF-8')
      stylist.work_hours = row['field_id_13'].encode('UTF-8')
      stylist.website_url = row['field_id_14'].encode('UTF-8')
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

  task :location => :environment do
    p 'sync locations!'
    db = get_database_client
    results = db.query("SELECT * FROM exp_weblog_data WHERE weblog_id = 5 AND entry_id = 4171")
    p "results.size = #{results.size}"
    count = results.size
    results.each_with_index do |row, idx|
      p "Processing (#{row['entry_id']}) #{idx + 1} of #{count}..."

      meta = db.query("SELECT * FROM exp_weblog_titles WHERE entry_id = #{row['entry_id']} LIMIT 1").first

      location = Location.where(:status => 'open').find_by(:legacy_id => row['entry_id'].to_s) || Location.new
      
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
        location.image_1 = open(get_img_src row['field_id_20']) unless row['field_id_20'].blank?
      rescue => e
        p "image 1 error = #{e.inspect}"
      end

      p "image 2"
      begin
      location.image_2 = open(get_img_src row['field_id_21']) unless row['field_id_21'].blank?
      rescue => e
        p "image 2 error = #{e.inspect}"
      end

      p "image 3"
      begin
      location.image_3 = open(get_img_src row['field_id_234']) unless row['field_id_234'].blank?
      rescue => e
        p "image 3 error = #{e.inspect}"
      end

      p "image 4"
      begin
      location.image_4 = open(get_img_src row['field_id_235']) unless row['field_id_235'].blank?
      rescue => e
        p "image 4 error = #{e.inspect}"
      end

      p "image 5"
      begin
      location.image_5 = open(get_img_src row['field_id_236']) unless row['field_id_236'].blank?
      rescue => e
        p "image 5 error = #{e.inspect}"
      end

      p "image 6"
      begin
      location.image_6 = open(get_img_src row['field_id_237']) unless row['field_id_237'].blank?
      rescue => e
        p "image 6 error = #{e.inspect}"
      end

      p "image 7"
      begin
      location.image_7 = open(get_img_src row['field_id_238']) unless row['field_id_238'].blank?
      rescue => e
        p "image 7 error = #{e.inspect}"
      end

      p "image 8"
      begin
      location.image_8 = open(get_img_src row['field_id_239']) unless row['field_id_239'].blank?
      rescue => e
        p "image 8 error = #{e.inspect}"
      end

      p "image 9"
      begin
      location.image_9 = open(get_img_src row['field_id_240']) unless row['field_id_240'].blank?
      rescue => e
        p "image 9 error = #{e.inspect}"
      end

      p "image 10"
      begin
      location.image_10 = open(get_img_src row['field_id_241']) unless row['field_id_241'].blank?
      rescue => e
        p "image 10 error = #{e.inspect}"
      end

      p "image 11"
      begin
      location.image_11 = open(get_img_src row['field_id_242']) unless row['field_id_242'].blank?
      rescue => e
        p "image 11 error = #{e.inspect}"
      end

      p "image 12"
      begin
      location.image_12 = open(get_img_src row['field_id_243']) unless row['field_id_243'].blank?
      rescue => e
        p "image 12 error = #{e.inspect}"
      end

      p "image 13"
      begin
      location.image_13 = open(get_img_src row['field_id_244']) unless row['field_id_244'].blank?
      rescue => e
        p "image 13 error = #{e.inspect}"
      end

      p "image 14"
      begin
      location.image_14 = open(get_img_src row['field_id_245']) unless row['field_id_245'].blank?
      rescue => e
        p "image 14 error = #{e.inspect}"
      end

      p "image 15"
      begin
      location.image_15 = open(get_img_src row['field_id_246']) unless row['field_id_246'].blank?
      rescue => e
        p "image 15 error = #{e.inspect}"
      end

      p "image 16"
      begin
      location.image_16 = open(get_img_src row['field_id_247']) unless row['field_id_247'].blank?
      rescue => e
        p "image 16 error = #{e.inspect}"
      end

      p "image 17"
      begin
      location.image_17 = open(get_img_src row['field_id_248']) unless row['field_id_248'].blank?
      rescue => e
        p "image 17 error = #{e.inspect}"
      end

      p "image 18"
      begin
      location.image_18 = open(get_img_src row['field_id_249']) unless row['field_id_249'].blank?
      rescue => e
        p "image 18 error = #{e.inspect}"
      end

      p "image 19"
      begin
      location.image_19 = open(get_img_src row['field_id_250']) unless row['field_id_250'].blank?
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

  def get_database_client
    Mysql2::Client.new(:host => '69.73.148.8', :port => 3306, :database => 'sola_expressengine', :username => 'sola_stylist', :password => 'lostinthedream2014', :local_infile => false, :secure_auth => false)
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