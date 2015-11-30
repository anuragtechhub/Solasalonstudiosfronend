class SearchController < PublicWebsiteController
  
  skip_before_filter :verify_authenticity_token

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

      # locations
      locations1 = Location.near(params[:query].downcase)
      locations2 = Location.where(:status => 'open').where('LOWER(state) LIKE ? OR LOWER(city) LIKE ? OR LOWER(name) LIKE ? OR LOWER(url_name) LIKE ?', query_param, query_param, query_param, query_param)
      @locations = locations1.open + locations2.open
      if @locations
        @locations.uniq!
        @locations.sort! { |a, b| a.name <=> b.name }
      end

      # stylists
      if params[:stylists] != 'hidden'
        @stylists = Stylist.where(:status => 'open').where('LOWER(business_name) LIKE ? OR LOWER(name) LIKE ? OR LOWER(url_name) LIKE ?', query_param, query_param, query_param).where.not(:location_id => nil)
        if @stylists
          @stylist = @stylists.open
          @stylists.uniq!
          @stylists.sort! { |a, b| a.name <=> b.name }
        end
      end
    end
  end
end
