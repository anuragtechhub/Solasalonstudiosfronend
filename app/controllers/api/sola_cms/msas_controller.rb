class Api::SolaCms::MsasController < Api::SolaCms::ApiController
  before_action :set_msa, only: %i[ show update destroy]

  #GET /Msas
  def index
    @msas = Msa.all
    render json: @msas
  end

  #POST /Msas
  def create
    @msa  =  Msa.new(msa_params)
    if @msa.save
      render json: @msa
    else
      render json: {error: "Unable to Create Location"}, status: 400
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
      render json: {error: "Unable to Update Msa."}, status: 400
    end  
  end 

  #DELETE /Msas/:id
  def destroy
    if @msa.destroy
      render json: {message: "Msa Successfully Deleted."}, status: 200
    else
      render json: {error: "Unable to Delete msa."}, status: 400
    end
  end 

  private

  def set_msa
    @msa = Msa.find(params[:id])
  end

  def msa_params
    params.require(:msa).permit(:name, :url_name, :legacy_id, :description, :tracking_code)
  end
end
