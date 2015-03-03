class SearchController < PublicWebsiteController
  def results
    if params[:query]
      query_param = "%#{params[:query]}%"

      # locations
      locations1 = Location.near(params[:query])
      locations2 = Location.where('state LIKE ? OR name LIKE ? OR url_name LIKE ?', query_param, query_param, query_param)
      @locations = locations1 + locations2
      if @locations
        @locations.uniq!
        @locations.sort! { |a, b| a.name <=> b.name }
      end

      # stylists
      @stylists = Stylist.where('business_name LIKE ? OR name LIKE ? OR url_name LIKE ?', query_param, query_param, query_param)
      if @stylists
        @stylists.uniq!
        @stylists.sort! { |a, b| a.name <=> b.name }
      end
    end
  end
end
