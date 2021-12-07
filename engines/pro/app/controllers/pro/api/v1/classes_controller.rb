module Pro
  class Api::V1::ClassesController < ApiController

    before_action :set_regions

    def index
      country = get_userable_country(params[:email])

      regions = []
      @regions.each do |region|
        region_classes = region.future_classes

        if region_classes && region_classes.size > 0
          total_pages = region_classes.size / 3 + (region_classes.size % 3 == 0 ? 0 : 1)
        else
          total_pages = 0
        end

        region = {
          :id => region.id,
          :name => region.name,
          :page => 0,
          :total_pages => total_pages,
          :classes => region_classes.limit(3),
        }

        regions << region
      end

      render :json => {
        :regions => regions
      }
    end

    def get
      render :json => SolaClass.find_by(:id => params[:id])
    end

    def load_more
      country = get_userable_country(params[:email])

      region = SolaClassRegion.find(params[:id])
      region_classes = region.future_classes.order(:end_date, :start_date)

      if region_classes && region_classes.size > 0
        total_pages = region_classes.size / 3 + (region_classes.size % 3 == 0 ? 0 : 1)
      else
        total_pages = 0
      end

      limit = 3
      page = params[:page].present? ? params[:page].to_i : 0
      region_classes = region_classes.limit(limit).offset(page * limit)

      render :json => {
        :id => region.id,
        :name => region.name,
        :page => page,
        :total_pages => total_pages,
        :classes => region_classes,
      }
    end

    private

    def set_regions
      @regions = SolaClassRegion.where(:id => SolaClass.pluck(:sola_class_region_id).uniq).order(:position => :asc).order('LOWER(name)')
    end

  end
end