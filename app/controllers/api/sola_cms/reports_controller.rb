# frozen_string_literal: true

class Api::SolaCms::ReportsController < Api::SolaCms::ApiController
  skip_before_action :restrict_api_access
  before_action :set_report, only: %i[ show update destroy]

  def index
    @reports = params[:search].present? ? search_report : Report.order("#{field} #{order}")
    @reports = paginate(@reports)
    render json:  { reports: @reports }.merge(meta: pagination_details(@reports))
  end

  def create
    @report  =  Report.new(report_params)
    if @report.save
      render json: @report, status: 200
    else
      Rails.logger.info(@report.errors.messages)
      render json: {error: @report.errors.messages}, status: 400  
    end
  end

  def show
    render json: @report
  end

  def update
    if @report.update(report_params)
      render json: {message: "Report Updated Successfully." }, status: 200
    else
      Rails.logger.info(@report.errors.messages)
      render json: { message: @report.errors.full_messages  }, status: 400
    end
  end

  def destroy
    if @report&.destroy
      render json: {message: "Report Deleted Successfully."}, status: 200
    else
      Rails.logger.info(@report.errors.messages)
      render json: {errors: format_activerecord_errors(@report.errors) }, status: 400
    end
  end

  private

  def set_report
    @report = Report.find_by(id: params[:id])
    render json: { message: 'Record not found' }, status: 400 unless @report.present?
  end

  def report_params
    params.require(:report).permit(:report_type, :email_address, :parameters)
  end

  def search_report
    Report.order("#{field} #{order}").search_by_email(params[:search])
  end 
end
