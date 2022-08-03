class Api::SolaCms::TestimonialsController < Api::SolaCms::ApiController
  before_action :get_testimonial, only: %i[ show update destroy]
  
  def index
    @testimonials = params[:search].present? ? search_testimonial : Testimonial.order("#{field} #{order}")
    @testimonials = paginate(@testimonials)
    render json:  { testimonials: @testimonials }.merge(meta: pagination_details(@testimonials))
  end

  def create
    testimonial = Testimonial.new(testimonial_params)
    if testimonial.save
      render json: testimonial, status: 200
    else
      Rails.logger.info(testimonial.errors.messages)
      render json: { message: testimonial.errors.full_messages  }
    end 
  end

  def show
    render json: @testimonial
  end

  def update
    if @testimonial&.update(testimonial_params)
      render json: { message: "Updated successfully." }
    else
      Rails.logger.info(@testimonial.errors.messages)
      render json: { message: @testimonial.errors.full_messages  }
    end 
  end

  def destroy
    if @testimonial&.destroy
      render json: { message: "deleted successfully."}
    else
      Rails.logger.info(@testimonial.errors.messages)
      render json: {errors: format_activerecord_errors(@testimonial.errors) }, status: 400
    end  
  end

  private

  def get_testimonial
    @testimonial = Testimonial.find_by(id: params[:id])
    render json: { message: 'Record not found' }, status: 400 unless @testimonial.present?
  end

  def testimonial_params
    params.require(:testimonial).permit(:name, :text, :region) 
  end

  def search_testimonial
    Testimonial.order("#{field} #{order}").search_testimonial(params[:search])
  end 
end