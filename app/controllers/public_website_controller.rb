class PublicWebsiteController < ApplicationController
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  layout 'public_website'

  before_action :set_locale, :auth_if_test#, :auth_if_canada

  helper_method :all_locations, :all_states, :all_locations_msas, :all_states_json, :all_locations_msas_json, :all_states_ca, :all_locations_ca_msas, :all_states_ca_json, :all_locations_ca_msas_json

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

  def all_states()
    if I18n.locale == :en
      # USA!
      return state_names
    else
      cache_key = "all_states/{I18n.locale}/#{Location.order(:updated_at => :desc).first.updated_at}"
      all_states = Rails.cache.fetch(cache_key) do
        return all_locations.select("DISTINCT(state)").order(:state => :asc).uniq.pluck(:state).map(&:strip).uniq
      end
      p "all_states=#{all_states}"
      return all_states
    end
  end

  def all_states_json
    # cache_key = "all_states_json/#{Location.order(:updated_at => :desc).first.updated_at}"
    # json = Rails.cache.fetch(cache_key) do
    #   return all_states.to_json
    # end
    # p "all_states_json=#{json}"
    # return json
    return all_states.to_json
  end

  def all_states_ca
      cache_key = "all_states_ca/#{Location.order(:updated_at => :desc).first.updated_at}"
      all_states = Rails.cache.fetch(cache_key) do
        return Location.where(:status => 'open').where(:country => 'CA').select("DISTINCT(state)").order(:state => :asc).uniq.pluck(:state).map(&:strip).uniq
      end
      p "all_states=#{all_states}"
      return all_states
  end

  def all_states_ca_json
    # cache_key = "all_states_json/#{Location.order(:updated_at => :desc).first.updated_at}"
    # json = Rails.cache.fetch(cache_key) do
    #   return all_states.to_json
    # end
    # p "all_states_json=#{json}"
    # return json
    return all_states_ca.to_json
  end

  def all_locations_msas
    cache_key = "all_locations_msas/#{Location.order(:updated_at => :desc).first.updated_at}/#{Msa.order(:updated_at => :desc).first.updated_at}"
    all_locations_msas = Rails.cache.fetch(cache_key) do
      sml = []

      all_locations.group_by(&:msa_name).sort.each do |msa_name, locations|
        if msa_name
          sml << {option_type: 'msa', value: msa_name, filtered_by: locations.first.state.strip}
          locations.sort{|a, b| a.name.downcase <=> b.name.downcase}.each do |location|
            sml << {option_type: 'location', value: {id: location.id, name: location.name}, filtered_by: location.state.strip}
          end
        end
      end

      #p "all_locations_msas #{sml}"

      return sml
    end
    return all_locations_msas
  end

  def all_locations_msas_json
    cache_key = "all_locations_msas_json/#{Location.order(:updated_at => :desc).first.updated_at}/#{Msa.order(:updated_at => :desc).first.updated_at}"
    json = Rails.cache.fetch(cache_key) do
      return all_locations_msas.to_json
    end
    return json
  end


  def all_locations_ca_msas
    cache_key = "all_locations_ca_msas/#{Location.order(:updated_at => :desc).first.updated_at}/#{Msa.order(:updated_at => :desc).first.updated_at}"
    all_locations_msas = Rails.cache.fetch(cache_key) do
      sml = []

      Location.where(:status => 'open').where(:country => 'CA').group_by(&:msa_name).sort.each do |msa_name, locations|
        if msa_name
          sml << {option_type: 'msa', value: msa_name, filtered_by: locations.first.state.strip}
          locations.sort{|a, b| a.name.downcase <=> b.name.downcase}.each do |location|
            sml << {option_type: 'location', value: {id: location.id, name: location.name}, filtered_by: location.state.strip}
          end
        end
      end

      #p "all_locations_msas #{sml}"

      return sml
    end
    return all_locations_msas
  end

  def all_locations_ca_msas_json
    cache_key = "all_locations_msas_ca_json/#{Location.order(:updated_at => :desc).first.updated_at}/#{Msa.order(:updated_at => :desc).first.updated_at}"
    json = Rails.cache.fetch(cache_key) do
      return all_locations_ca_msas.to_json
    end
    return json
  end

  def state_names
    %w(Alaska Alabama Arkansas Arizona California Colorado Connecticut District\ of\ Columbia Delaware Florida Georgia Hawaii Iowa Idaho Illinois Indiana Kansas Kentucky Louisiana Massachusetts Maryland Maine Michigan Minnesota Missouri Mississippi Montana North\ Carolina North\ Dakota Nebraska New\ Hampshire New\ Jersey New\ Mexico Nevada New\ York Ohio Oklahoma Oregon Pennsylvania Rhode\ Island South\ Carolina South\ Dakota Tennessee Texas Utah Virginia Vermont Washington Wisconsin West\ Virginia Wyoming)
  end

  def set_locale
    #p "set_locale #{request.domain}"
    if request.domain == 'solasalonstudios.ca' || request.domain == 'localhost'
      I18n.locale = 'en-CA' 
    elsif request.domain == 'com.br' || request.domain == 'com.br/' #|| request.domain == 'localhost'
      I18n.locale = 'pt-BR'
    else
      I18n.locale = 'en'
    end
  end

end
