class Api::SolaCms::CategoriesController < Api::SolaCms::ApiController
  before_action :get_category, only: %i[ show update destroy]

  def index
    @categories =  params[:search].present? ? search_categories_by_columns : Category.order("#{field} #{order}")
    render json: { categories: @categories } and return if params[:all] == "true"
    @categories = paginate(@categories)
    render json:  { categories: @categories }.merge(meta: pagination_details(@categories))
  end

  def create
    begin
      @category = Category.new(category_params)
      if @category.save
        create_categoriables(@category)
        render json: @category, status: 200
        # render json: {category: @category, categoriables: @category.categoriables}
      end  
    rescue ActiveRecord::RecordNotUnique => error
      render json: {error: "Name and Sulg already exists, category name and slug must be unique." }, status: 409
      Rails.logger.error(@category.errors.messages)
    end 
  end 

  def show
    render json: @category, status: 200
  end 

  def update
    begin 
      if @category.update(category_params)
        create_categoriables(@category)
        render json: {message: "Successfully Updated."}, status: 200
      end  
    rescue ActiveRecord::RecordNotUnique => error
      render json: {error: "Name and Sulg alredy exists, category name and slug must be unique." }, status: 409 
      Rails.logger.error(@category.errors.messages)
    end  
  end 

  def destroy
    if @category&.destroy
      render json: {message: "Successfully Deleted."}, status: 200
    else
      Rails.logger.error(@category.errors.messages)
      render json: {errors: format_activerecord_errors(@category.errors) }, status: 400
    end
  end

  private

  def get_category
    @category = Category.find_by(id: params[:id])
    render json: { message: 'Record not found' }, status: 400 unless @category.present?
  end

  def category_params
    params.require(:category).permit(:name, :slug)
  end

  def create_categoriables(category)
    category.blog_ids = ids_params[:blog_ids] 
    category.tool_ids = ids_params[:tool_ids] 
    category.deal_ids = ids_params[:deal_ids] 
    category.video_ids = ids_params[:video_ids] 
    category.tag_ids = ids_params[:tag_ids] 
    category.franchise_article_ids = ids_params[:franchise_article_ids]
  end

  def ids_params
    params.require(:category).permit( blog_ids: [], deal_ids: [], tool_ids: [], video_ids: [], tag_ids: [], franchise_article_ids: [] )
  end
  
  def search_categories_by_columns
    Category.order("#{field} #{order}").search_categories_by_columns(params[:search])
  end 
end

