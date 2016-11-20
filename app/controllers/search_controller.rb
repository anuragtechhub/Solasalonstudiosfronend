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
      locations1 = Location.near(params[:query].downcase).where(:country => (I18n.locale == :en ? 'US' : 'CA'))
      locations2 = Location.where(:country => (I18n.locale == :en ? 'US' : 'CA')).where(:status => 'open').where('LOWER(state) LIKE ? OR LOWER(city) LIKE ? OR LOWER(name) LIKE ? OR LOWER(url_name) LIKE ?', query_param, query_param, query_param, query_param)
      locations3 = Location.where(:msa_id => Msa.where('LOWER(name) LIKE ?', query_param).select(:id).to_a)

      @locations = locations1.open + locations2.open + locations3.open
      if @locations
        @locations.uniq!
        @locations.sort! { |a, b| a.name <=> b.name }
      end

      # stylists
      if params[:stylists] != 'hidden'
        @stylists = Stylist.joins("INNER JOIN locations ON locations.id = stylists.location_id AND locations.country = '#{I18n.locale == :en ? 'US' : 'CA'}' AND locations.status = 'open'").where(:status => 'open').where('LOWER(stylists.business_name) LIKE ? OR LOWER(stylists.name) LIKE ? OR LOWER(stylists.url_name) LIKE ?', query_param, query_param, query_param).where.not(:location_id => nil)
        if @stylists
          @stylist = @stylists.open
          @stylists.uniq!
          @stylists.sort! { |a, b| a.name <=> b.name }
        end
      end

      # blog posts
      @posts = Blog.where('status = ?', 'published').where('LOWER(title) LIKE ? OR LOWER(body) LIKE ? OR LOWER(author) LIKE ?', query_param, query_param, query_param).order(:publish_date => :desc)
    end
  end
end
