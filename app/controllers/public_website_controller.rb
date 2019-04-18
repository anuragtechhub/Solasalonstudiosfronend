class PublicWebsiteController < ApplicationController
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  layout 'public_website'

  before_action :set_locale, :auth_if_test#, :auth_if_canada

  helper_method :all_locations, :all_states, :states_msas_locations

  #http_basic_authenticate_with :name => "ohcanada", :password => "tragicallyhip", :if => 

  # def auth_if_canada
  #   if I18n.locale != :en
  #     authenticate_or_request_with_http_basic 'canada' do |name, password|
  #       name == 'ocanada' && password == 'trudeau'
  #     end
  #   end
  # end

  def auth_if_test
    #p "request.fullpath=#{request.fullpath}, #{request.fullpath.include?('sejasola')}"
    #p "ENV['PASSWORD_PROTECT']=#{ENV['PASSWORD_PROTECT']}"
    if ENV['PASSWORD_PROTECT'] == 'YES' && !request.fullpath.include?('sejasola')
      #p "AUTH IT UP"
      authenticate_or_request_with_http_basic 'test' do |name, password|
        name == 'phish' && password == 'food'
      end
    end
  end

  def all_locations
    if I18n.locale == :en
      @all_locations ||= Location.where(:status => 'open').where(:country => 'US')
    elsif I18n.locale.to_s == 'en-CA'
      @all_locations ||= Location.where(:status => 'open').where(:country => 'CA')
    elsif I18n.locale.to_s == 'pt-BR'
      @all_locations ||= Location.where(:status => 'open').where(:country => 'BR')
    end
  end

  def all_states
    all_locations.select("DISTINCT(state)").order(:state => :asc).uniq.pluck(:state)
  end

  def states_msas_locations
    sml = []

    all_locations.select("DISTINCT(state)").order(:state => :asc).each do |state|
      sml << {list_type: 'state', value: state}
      Location.where(:state => state, :status => 'open').order(:name => :asc).group_by(&:msa_name).sort.each do |msa_name, locations|
        if msa_name
          sml << {list_type: 'msa', value: msa_name}
          locations.sort{ |a, b| a.name.downcase <=> b.name.downcase }.each do |location|
            sml << {list_type: 'location', value: location}
          end
        end
      end
    end

    p "states_msas_locations #{sml}"

    sml
  end

  def set_locale
    #p "set_locale #{request.domain}"
    if request.domain == 'solasalonstudios.ca'#|| request.domain == 'localhost'
      I18n.locale = 'en-CA' 
    elsif request.domain == 'com.br' || request.domain == 'com.br/' #|| request.domain == 'localhost'
      I18n.locale = 'pt-BR'
    else
      I18n.locale = 'en'
    end
  end

end
