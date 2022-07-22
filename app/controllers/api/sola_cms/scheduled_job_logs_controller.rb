class Api::SolaCms::ScheduledJobLogsController < Api::SolaCms::ApiController
  before_action :get_job_log, only: %i[ show destroy]

  def index
    @job_logs = ScheduledJobLog.all
    render json: @job_logs
  end

  def show
    render json: @job_log
  end 

  def destroy
    if @job_log&.destroy
      render json: {message: "Log Deleted Successfully."}, status: 200
    else
      @job_log.errors.messages
      Rails.logger.info(@job_log.errors.messages)
    end
  end 

  private

  def get_job_log
    @job_log = ScheduledJobLog.find_by(id: params[:id])
    render json: { message: 'Record not found' }, status: 400 unless @job_log.present?
  end

end
