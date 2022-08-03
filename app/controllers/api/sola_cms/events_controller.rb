class Api::SolaCms::EventsController < Api::SolaCms::ApiController
    before_action :set_event, only: %i[ show update destroy]
    
    def index
      @events = params[:search].present? ? search_event_by_columns : Event.order("#{field} #{order}")
      render json: { events: @events } and return if params[:all] == "true"
      @events = paginate(@events)
      render json: { events: @events }.merge(meta: pagination_details(@events))
    end

    def create
      @event = Event.new(event_params)
      if @event.save
        render json: @event
      else
        Rails.logger.info(@event.errors.messages)
        render json: {error: @event.errors.messages}, status: 400
      end
    end

    def show
      render json: @event
    end

    def update
      if @event.update(event_params)
        render json: {message: "Event successfully updated."}, status: 200
      else
        Rails.logger.info(@event.errors.messages)
        render json: {error: @event.errors.messages}, status: 400
      end
    end

    def destroy
      if @event&.destroy
        render json: {message: "Event successfully deleted."}, status: 200
      else
        @event.errors.messages
        Rails.logger.info(@event.errors.messages)
      end
    end

    private

    def set_event
      @event = Event.find(params[:id])
    end

    def event_params
      params.require(:event).permit(:category, :action, :source, :brand_id, :deal_id, :tool_id, :sola_class_id, :video_id, :value, :platform, :userable_id, :userable_type)
    end

    def search_event_by_columns
      Event.order("#{field} #{order}").search_event_by_columns(params[:search])
    end
end