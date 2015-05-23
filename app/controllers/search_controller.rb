class SearchController < PublicWebsiteController
  def results
    if params[:query]
      query_param = "%#{params[:query].downcase.gsub(/\s/, '%')}%"

      # locations
      locations1 = Location.near(params[:query])
      locations2 = Location.where('LOWER(state) LIKE ? OR LOWER(name) LIKE ? OR LOWER(url_name) LIKE ? AND LOWER(status) = ?', query_param, query_param, query_param, 'open')
      @locations = locations1.open + locations2.open
      if @locations
        @locations.uniq!
        @locations.sort! { |a, b| a.name <=> b.name }
      end

      # stylists
      if params[:stylists] != 'hidden'
        @stylists = Stylist.where('LOWER(business_name) LIKE ? OR LOWER(name) LIKE ? OR LOWER(url_name) LIKE ? AND LOWER(status) = ?', query_param, query_param, query_param, 'open')
        if @stylists
          @stylist = @stylists.open
          @stylists.uniq!
          @stylists.sort! { |a, b| a.name <=> b.name }
        end
      end
    end
  end
end
