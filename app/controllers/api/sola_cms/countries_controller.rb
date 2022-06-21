class Api::SolaCms::CountriesController < Api::SolaCms::ApiController

  #GET /countries
  def index
    @countries = Country.all
    render json: @countries
  end

  
end
