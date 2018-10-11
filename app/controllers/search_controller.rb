class SearchController < PublicWebsiteController
    
  require 'uri'
  skip_before_filter :verify_authenticity_token
  
  def stylist_search
    #p "ip=#{request.remote_ip}"
    #if request.remote_ip == '127.0.0.1'
    #  @location_name = "Denver, Colorado"
    #else
    #location = Geokit::Geocoders::IpGeocoder.geocode('12.215.42.19')
    #p "location=#{location.inspect}"
    #end
    #p "@location_name=#{@location_name}"
    render :layout => 'booknow'
  end

  def stylist_results
    results_response = `curl -X GET \
    '#{ENV['GLOSS_GENIUS_API_URL']}search?#{gloss_genius_search_query_string}' \
    -H 'api_key: #{ENV['GLOSS_GENIUS_API_KEY']}' \
    -H 'device_id: #{params[:fingerprint]}'`

    #p "results_response=#{results_response}"

    begin
      @professionals = JSON.parse(results_response)
      @date = DateTime.parse(params[:date]) || DateTime.now
      #@locations = Location.near([params[:lat].to_f, params[:lng].to_f], 11)
      @locations = Location.where(:id => get_location_id(@professionals))
      
      if params[:location_id].present?
        @location = Location.find_by(:id => params[:location_id])
      end
    rescue
      p "ERROR WITH THIS CALL"
    end
    
    #p "@locations=#{@locations.size}"
    #p "@date=#{@date}"
    #p "@professionals=#{@professionals}"
    render :layout => 'booknow'
  end

  def results
    # if params[:query]

    #   @locations = Location.near("%#{params[:query].downcase.gsub(/\s/, '%')}%").to_a
    #   @stylists = []

    #   params[:query] = params[:query].strip
    #   params[:query].split(' ').each do |q|
    #     query_param = "%#{q.downcase}%"

    #     @locations.concat Location.where(:status => 'open').where('LOWER(state) LIKE ? OR LOWER(name) LIKE ? OR LOWER(url_name) LIKE ?', query_param, query_param, query_param).to_a
    #     @stylists.concat Stylist.where(:status => 'open').where('LOWER(business_name) LIKE ? OR LOWER(name) LIKE ? OR LOWER(url_name) LIKE ?', query_param, query_param, query_param).to_a if params[:stylists] != 'hidden'
    #   end

    #   @locations = @locations.uniq.sort { |a, b| a.name <=> b.name } if @locations
    #   @stylists = @stylists.uniq.sort { |a, b| a.name <=> b.name } if @stylists
    # end

    if params[:query]
      query_param = "%#{params[:query].downcase.gsub(/\s/, '%')}%"

      if /^[0-9]{5}(?:-[0-9]{4})?$/.match(params[:query])
        # zip code location
        @locations = Location.where(:country => (I18n.locale == :en ? 'US' : 'CA')).near(params[:query], 20)
      else
        # locations (default)
        locations1 = Location.near(params[:query].downcase).where(:country => (I18n.locale == :en ? 'US' : 'CA'))
        locations2 = Location.where(:country => (I18n.locale == :en ? 'US' : 'CA')).where(:status => 'open').where('LOWER(state) LIKE ? OR LOWER(city) LIKE ? OR LOWER(name) LIKE ? OR LOWER(url_name) LIKE ?', query_param, query_param, query_param, query_param).where(:country => (I18n.locale == :en ? 'US' : 'CA'))
        locations3 = Location.where(:msa_id => Msa.where('LOWER(name) LIKE ?', query_param).select(:id).to_a).where(:country => (I18n.locale == :en ? 'US' : 'CA'))


        @locations = locations1.open + locations2.open + locations3.open
        if @locations
          @locations.uniq!
          @locations.sort! { |a, b| a.name <=> b.name }
        end

        exact_match_location = Location.where(:country => (I18n.locale == :en ? 'US' : 'CA')).where(:status => 'open').where('LOWER(name) = ?', params[:query].downcase).first
        if exact_match_location
          #p "yes exact match location #{exact_match_location.name}"
          @locations = @locations.unshift(exact_match_location)
          @locations.uniq!
        end
      end

      # stylists
      if params[:stylists] != 'hidden'
        stylists_name = Stylist.where('website_name IS NULL OR website_name = ?', '').joins("INNER JOIN locations ON locations.id = stylists.location_id AND locations.country = '#{I18n.locale == :en ? 'US' : 'CA'}' AND locations.status = 'open'").where(:status => 'open').where('LOWER(stylists.business_name) LIKE ? OR LOWER(stylists.name) LIKE ? OR LOWER(stylists.url_name) LIKE ?', query_param, query_param, query_param).where.not(:location_id => nil)
        stylists_website_name = Stylist.where('website_name IS NOT NULL AND website_name != ?', '').joins("INNER JOIN locations ON locations.id = stylists.location_id AND locations.country = '#{I18n.locale == :en ? 'US' : 'CA'}' AND locations.status = 'open'").where(:status => 'open').where('LOWER(stylists.business_name) LIKE ? OR LOWER(stylists.website_name) LIKE ? OR LOWER(stylists.url_name) LIKE ?', query_param, query_param, query_param).where.not(:location_id => nil)
        
        # service_type filter?
        #p "params[:service_type]=#{params[:service_type]}"
        if params[:service_type].present? && params[:service_type] != 'all_types'

          if params[:service_type] == 'skincare'
            service_type_filter = 'skin = ?'
          else
            service_type_filter = "#{params[:service_type]} = ?"
          end

          # hair, makeup, nails, skincare
          stylists_name = stylists_name.where(service_type_filter, true)
          stylists_website_name = stylists_website_name.where(service_type_filter, true)
        end

        @stylists = (stylists_name + stylists_website_name)#.flatten!

        if @stylists
          @stylists.uniq!
          @stylists.sort! { |a, b| a.name <=> b.name }
        end
      end

      # blog posts
      @posts = Blog.where('status = ?', 'published').where('LOWER(title) LIKE ? OR LOWER(body) LIKE ? OR LOWER(author) LIKE ?', query_param, query_param, query_param).order(:publish_date => :desc)

      @results = @locations.size + @stylists.size + @posts.size
    end

  end

  private

  def gloss_genius_search_query_string
    query_string = "query=#{CGI.escape params[:query]}&latitude=#{params[:lat]}&longitude=#{params[:lng]}"

    if params[:location_id].present?
      query_string = query_string + "&org_location_id=#{params[:location_id]}"
    end

    #p "query_string=#{query_string}"

    return query_string
  end

  def get_location_id(professionals)
    location_ids = []

    professionals.each do |pro|
      location_ids << pro["org_location_id"]
    end

    return location_ids.uniq
  end

end
