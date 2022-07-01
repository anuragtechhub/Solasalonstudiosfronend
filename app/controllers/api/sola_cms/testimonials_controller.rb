class Api::SolaCms::TestimonialsController < Api::SolaCms::ApiController
  before_action :get_testimonial, only: %i[ show update destroy]
  
  def index
    if params[:search].present?
      testimonials = Testimonial.search_testimonial(params[:search])
      testimonials = paginate(testimonials)
      render json:  { testimonials: testimonials }.merge(meta: pagination_details(testimonials))
    else  
      testimonials = Testimonial.all
      testimonials = paginate(testimonials)
      render json: { testimonials: testimonials }.merge(meta: pagination_details(testimonials))
    end
  end

  def create
    testimonial = Testimonial.new(testimonial_params)
    if testimonial.save
       render json: testimonial
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
end