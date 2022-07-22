class Api::SolaCms::CallfireLogsController < Api::SolaCms::ApiController
  #GET /call_fire_logs
  def index
    @call_fire_logs = CallfireLog.all
    if params[:search].present? 
      callfire_logs = CallfireLog.search_by_name(params[:search])
      callfire_logs = paginate(callfire_logs)
      render json:  { callfire_logs: callfire_logs }.merge(meta: pagination_details(callfire_logs))
    elsif params[:all] == "true"
      render json: { callfire_logs: @callfire_logs }
     else 
        callfire_logs = CallfireLog.all
        callfire_logs = paginate(callfire_logs)
        render json: { callfire_logs: callfire_logs }.merge(meta: pagination_details(callfire_logs))
     end
   end
end