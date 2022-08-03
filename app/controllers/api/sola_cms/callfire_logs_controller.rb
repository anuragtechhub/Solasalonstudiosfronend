class Api::SolaCms::CallfireLogsController < Api::SolaCms::ApiController
  #GET /call_fire_logs
  def index
    @callfire_logs = params[:search].present? ? search_logs_by_name : CallfireLog.order("#{field} #{order}")
    @callfire_logs = paginate(@callfire_logs)
    render json: { callfire_logs: @callfire_logs }.merge(meta: pagination_details(@callfire_logs))
  end

  private

  def search_logs_by_name
    CallfireLog.order("#{field} #{order}").search_by_name(params[:search])
  end

end

