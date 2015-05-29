class SearchController < PublicWebsiteController
  
  skip_before_filter :verify_authenticity_token

  def results
    if params[:query]

      # @locations = Location.where(:status => 'open')
      # @stylists = Stylist.where(:status => 'open')

      # params[:query] = params[:query].strip
      # params[:query].split(' ').each do |q|
      #   query_param = "%#{q.downcase}%"

      # end

      query_param = "%#{params[:query].downcase.gsub(/\s/, '%')}%"

      # locations
      locations1 = Location.near(params[:query])

      if params[:query]

      locations2 = Location.where(:status => 'open').where('LOWER(state) LIKE ? OR LOWER(name) LIKE ? OR LOWER(url_name) LIKE ?', query_param, query_param, query_param)
      @locations = locations1.open + locations2.open
      if @locations
        @locations.uniq!
        @locations.sort! { |a, b| a.name <=> b.name }
      end

      # stylists
      if params[:stylists] != 'hidden'
        @stylists = Stylist.where(:status => 'open').where('LOWER(business_name) LIKE ? OR LOWER(name) LIKE ? OR LOWER(url_name) LIKE ?', query_param, query_param, query_param)
        if @stylists
          @stylist = @stylists.open
          @stylists.uniq!
          @stylists.sort! { |a, b| a.name <=> b.name }
        end
      end
    end
  end
end
