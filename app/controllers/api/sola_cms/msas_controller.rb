class Api::SolaCms::MsasController < Api::SolaCms::ApiController
  before_action :set_msa, only: %i[ show update destroy]

  #GET /Msas
  def index
    if params[:search].present? 
      msas = Msa.order("#{field} #{order}").search_by_id_name_and_location(params[:search])
      msas = paginate(msas)
      render json:  { msas: msas }.merge(meta: pagination_details(msas))
    elsif params[:all] == "true"
      render json: { msas: @msas }
    else 
      msas = Msa.order("#{field} #{order}")
      msas = paginate(msas)
      render json: { msas: msas }.merge(meta: pagination_details(msas))
    end
  end

  #POST /Msas
  def create
    @msa  =  Msa.new(msa_params)
    if @msa.save
      render json: @msa, status: 200
    else
      Rails.logger.info(@msa.errors.messages)
      render json: {error: @msa.errors.messages}, status: 400
    end 
  end 

  #GET /Msas/:id
  def show
    render json: @msa
  end 

  #PUT /Msas/:id
  def update
    if @msa.update(msa_params)
      render json: {message: "Msa Successfully Updated."}, status: 200
    else
      Rails.logger.info(@msa.errors.messages)
      render json: {error: @msa.errors.messages}, status: 400
    end  
  end 

  #DELETE /Msas/:id
  def destroy
    if @msa&.destroy
      render json: {message: "Msa Successfully Deleted."}, status: 200
    else
      Rails.logger.info(@msa.errors.messages)
      render json: {message: format_activerecord_errors(@msa.errors) }, status: 400
    end
  end 

  private

  def set_msa
    @msa = Msa.find_by(id: params[:id])
    render json: { message: 'Record not found' }, status: 400 unless @msa.present?
  end

  def msa_params
    params.require(:msa).permit(:name, :url_name, :legacy_id, :description, :tracking_code, location_ids: [])
  end

  def search_msa

  end
end
