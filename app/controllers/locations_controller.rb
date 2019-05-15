class LocationsController < PublicWebsiteController

  before_action :map_defaults

  STATE_ABBR_TO_NAME = {
    'AL' => 'Alabama',
    'AK' => 'Alaska',
    'AS' => 'America Samoa',
    'AZ' => 'Arizona',
    'AR' => 'Arkansas',
    'CA' => 'California',
    'CO' => 'Colorado',
    'CT' => 'Connecticut',
    'DE' => 'Delaware',
    'DC' => 'District of Columbia',
    'FM' => 'Federated States Of Micronesia',
    'FL' => 'Florida',
    'GA' => 'Georgia',
    'GU' => 'Guam',
    'HI' => 'Hawaii',
    'ID' => 'Idaho',
    'IL' => 'Illinois',
    'IN' => 'Indiana',
    'IA' => 'Iowa',
    'KS' => 'Kansas',
    'KY' => 'Kentucky',
    'LA' => 'Louisiana',
    'ME' => 'Maine',
    'MH' => 'Marshall Islands',
    'MD' => 'Maryland',
    'MA' => 'Massachusetts',
    'MI' => 'Michigan',
    'MN' => 'Minnesota',
    'MS' => 'Mississippi',
    'MO' => 'Missouri',
    'MT' => 'Montana',
    'NE' => 'Nebraska',
    'NV' => 'Nevada',
    'NH' => 'New Hampshire',
    'NJ' => 'New Jersey',
    'NM' => 'New Mexico',
    'NY' => 'New York',
    'NC' => 'North Carolina',
    'ND' => 'North Dakota',
    'OH' => 'Ohio',
    'OK' => 'Oklahoma',
    'OR' => 'Oregon',
    'PW' => 'Palau',
    'PA' => 'Pennsylvania',
    'PR' => 'Puerto Rico',
    'RI' => 'Rhode Island',
    'SC' => 'South Carolina',
    'SD' => 'South Dakota',
    'TN' => 'Tennessee',
    'TX' => 'Texas',
    'UT' => 'Utah',
    'VT' => 'Vermont',
    'VI' => 'Virgin Island',
    'VA' => 'Virginia',
    'WA' => 'Washington',
    'WV' => 'West Virginia',
    'WI' => 'Wisconsin',
    'WY' => 'Wyoming'
  }

  def find_salon
    if params[:query]
      query_param = "%#{params[:query].downcase.gsub(/\s/, '%')}%"

      # locations
      locations1 = Location.near(params[:query].downcase).where(:country => (I18n.locale == :en ? 'US' : 'CA'))
      locations2 = Location.where(:country => (I18n.locale == :en ? 'US' : 'CA')).where(:status => 'open').where('LOWER(state) LIKE ? OR LOWER(city) LIKE ? OR LOWER(name) LIKE ? OR LOWER(url_name) LIKE ?', query_param, query_param, query_param, query_param).where(:country => (I18n.locale == :en ? 'US' : 'CA'))
      locations3 = Location.where(:msa_id => Msa.where('LOWER(name) LIKE ?', query_param).select(:id).to_a).where(:country => (I18n.locale == :en ? 'US' : 'CA'))

      @locations = locations1.open + locations2.open + locations3.open
      if @locations
        @locations.uniq!
        @locations.sort! { |a, b| a.name <=> b.name }
      end
    end

    render :json => @locations.to_json(:only => [:name, :url_name, :email_address_for_inquiries, :general_contact_name, :phone_number, :city, :state], :methods => [:full_address])
  end

  def index
    @country = country_from_locale
    @locations = Location.where(:status => 'open').where(:country => @country)
    @states = @locations.select('DISTINCT state').order(:state => :asc).to_a.reject{|l| l.state.blank? }

    p "@locations=#{@locations.inspect}"
    p "@states=#{@states.to_a.length}"

    @last_location = Location.order(:updated_at => :desc).first
    @last_msa = Msa.order(:updated_at => :desc).first
  end

  def region
    @msa = Msa.find_by(:url_name => params[:url_name])

    unless @msa
      @msa = Msa.find_by(:url_name => params[:url_name].split('_').join('-'))
      redirect_to region_path(:url_name => @msa.url_name) if @msa
    end

    if I18n.locale == :en
      @all_locations = Location.where(:status => 'open').where(:country => 'US')
    else
      @all_locations = Location.where(:status => 'open').where(:country => 'CA')#.where.not(:id => 362)
    end
    
    if @msa
      @locations = @all_locations.where('msa_id = ?', @msa.id)
      params[:state] = @locations.first.state
    else
      redirect_to :locations
    end
  end

  def city
    @all_locations = Location.where(:status => 'open')
    query_param = "%#{params[:city]}%"

    #locations1 = Location.where(:status => 'open').near(params[:city])
    if I18n.locale == :en
      @locations = Location.where(:status => 'open').where(:country => 'US')
    else
      @locations = Location.where(:status => 'open').where(:country => 'CA')#.where.not(:id => 362)
    end

    @locations = @locations.where('city LIKE ?', query_param)
    #@locations = locations1 + locations2
    if @locations
      @locations.uniq!
      @locations.sort! { |a, b| a.name <=> b.name }
    end
    redirect_to :locations unless @locations.size > 0 && @lat && @lng
  end

  def state
    if I18n.locale == :en
      @all_locations = Location.where(:status => 'open').where(:country => 'US')
    else
      @all_locations = Location.where(:status => 'open').where(:country => 'CA')#.where.not(:id => 362)
    end

    query_param = "#{params[:state].downcase.gsub(/-/, ' ')}".strip if params[:state]

    p "query_param=#{query_param}"
    
    if I18n.locale == :en
      @locations = Location.where(:status => 'open').where('lower(state) = ?', query_param).where(:country => 'US')
    else
      @locations = Location.where(:status => 'open').where('lower(state) = ?', query_param).where(:country => 'CA')#.where.not(:id => 362)
    end
    
    redirect_to :locations unless @locations.size > 0 && @lat && @lng
  end

  def salon
    @location = Location.find_by(:url_name => params[:url_name])
    @articles = Article.where(:location_id => @location.id).order('created_at DESC')
    
    if @location
      @lat = @location.latitude
      @lng = @location.longitude
      @zoom = 14
      @locations = [@location]
    else
      redirect_to :locations
    end
  end

  def usa
    p "request.remote_ip=#{request.remote_ip}"
    results = Geocoder.search(request.remote_ip)
    p "results=#{results.inspect}"
    if results && results.length > 0
      result = results.first
      p "result=#{result.city}, #{result.state}, #{result.latitude}, #{result.longitude}"
      if result && result.state.present?
        p "redirect1"
        p "STATE_ABBR_TO_NAME=#{STATE_ABBR_TO_NAME[result.state]}"
        redirect_to locations_by_state_path(params.merge({:state => STATE_ABBR_TO_NAME[result.state]})), :status => 301
      else
        p "redirect2"
        redirect_to locations_path(params), :status => 301
      end
    else
      p "redirect3"
      redirect_to locations_path(params), :status => 301
    end
  rescue => e
    p "redirect4"
    redirect_to locations_path(params), :status => 301
  end

  def state_abbr_to_name(abbr)

  end

  def old_salon
    redirect_to salon_location_path(:url_name => params[:url_name].split('_').join('-'))
  end

  def salon_redirect
    @location = Location.find_by(:url_name => params[:url_name])
    
    if @location && @location.state && @location.city
      redirect_to salon_location_path(@location.state, @location.city, @location.url_name).gsub(/\./, '')
    else
      redirect_to :locations
    end
  end

  def stylists
    @location = Location.find_by(:url_name => params[:url_name])

    if @location && @location.stylists
      @stylists = @location.stylists

      if (params[:service]) 
        @stylists = @location.stylists.select { |s| true if (s.services.include?(params[:service]) || (params[:service].downcase == 'other' && s.other_service)) }
      end

      @lat = @location.latitude
      @lng = @location.longitude
      @zoom = 14
      @locations = [@location]
    else
      redirect_to :locations
    end
  end

  def fullscreen
    @locations = Location.all
    render :layout => 'fullscreen'
  end

  # custom location redirects
  def sixthaveredirect
    redirect_to 'https://www.solasalonstudios.com/locations/tacoma-6th-avenue'
  end

  private 

  def country_from_locale
    p "country_from_locale=#{I18n.locale.to_s}"
    if I18n.locale.to_s == 'pt-BR'
      return 'BR'
    elsif  I18n.locale.to_s == 'en-CA'
      return 'CA'
    else
      return 'US'
    end
  end

  def map_defaults
    if params[:action] == 'city'
      coords = Geocoder.coordinates("#{params[:city]}, #{params[:state]}")
      if coords && coords.size > 1
        @lat = coords[0]
        @lng = coords[1]
        @zoom = 9
      end
    elsif params[:action] == 'state'
      coords = Geocoder.coordinates("#{params[:state]}")
      if coords && coords.size > 1
        @lat = coords[0]
        @lng = coords[1]
        @zoom = 6
      end
    else
      @lat = 38.850033
      @lng = -95.6500523
      @zoom = 4
    end
  end
end
