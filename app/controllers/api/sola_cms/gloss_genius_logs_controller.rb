class Api::SolaCms::GlossGeniusLogsController < Api::SolaCms::ApiController
  before_action :get_gloss_genius_log, only: %i[ show update destroy]

  #GET /gloss_genius_logs
  def index
    @gloss_genius_logs = GlossGeniusLog.all
    if params[:all] == "true"
      render json: { gloss_genius_logs: @gloss_genius_logs }
    else
      gloss_genius_logs = paginate(@gloss_genius_logs)    
      render json: { gloss_genius_logs: gloss_genius_logs }.merge(meta: pagination_details(gloss_genius_logs))
    end
  end

  #POST /gloss_genius_logs
  def create
    @gloss_genius_log  =  GlossGeniusLog.new(gloss_genius_log_params)
    if @gloss_genius_log.save
      render json: @gloss_genius_log
    else
      Rails.logger.info(@gloss_genius_log.errors.messages)
      render json: {error: @gloss_genius_log.errors.messages}, status: 400
    end 
  end 

  #GET /gloss_genius_logs/:id
  def show
    render json: @gloss_genius_log
  end 

  #PUT /gloss_genius_logs/:id
  def update
    if @gloss_genius_log.update(gloss_genius_log_params)
      render json: {message: "Gloss Genius Log Successfully Updated."}, status: 200
    else
      Rails.logger.info(@gloss_genius_log.errors.messages)
      render json: {error: @gloss_genius_log.errors.messages}, status: 400
    end  
  end 

  #DELETE /gloss_genius_logs/:id
  def destroy
    if @gloss_genius_log&.destroy
      render json: {message: "Gloss Genius Log Successfully Deleted."}, status: 200
    else
      @gloss_genius_log.errors.messages
      Rails.logger.info(@gloss_genius_log.errors.messages)
    end
  end 

  private

  def get_gloss_genius_log
    @gloss_genius_log = GlossGeniusLog.find(params[:id])
  end

  def gloss_genius_log_params
    params.require(:gloss_genius_log).permit(:action_name, :ip_address, :host, :request_body)
  end
end
