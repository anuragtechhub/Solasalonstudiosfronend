module RailsAdmin
  module Config
    module Actions
      class CustomExport < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :link_icon do
          'icon-share'
        end

        register_instance_option :collection? do
          true # Makes action tab visible for the collection
        end

        register_instance_option :http_methods do
          %i[get post]
        end

        register_instance_option :controller do
          proc do
            if request.get?
              render action: @action.template_name
            elsif request.post?
              begin
                from = Time.zone.parse(params[:from]).beginning_of_day
                to = Time.zone.parse(params[:to]).end_of_day

                # # Prepare headers for streaming
                response.headers.delete('Content-Length')
                response.headers['Cache-Control'] = 'no-cache'
                response.headers['X-Accel-Buffering'] = 'no'
                #response.headers['Content-Type'] = 'text/event-stream'
                response.headers['Content-Type'] ||= 'text/csv'

                # There's an issue in rack where ActionController::Live doesn't work with the ETags middleware
                # See https://github.com/rack/rack/issues/1619#issuecomment-606315714
                #response.headers['ETag'] = '0'
                response.headers['Last-Modified'] = Time.now.httpdate

                headers['Content-Disposition'] = "attachment; filename=\"#{@model_name.to_s.pluralize}-#{Date.current.to_s}.csv\""
                #headers['Content-Type'] ||= 'text/csv'

                @schema = HashHelper.symbolize(params[:schema].slice(:except, :include, :methods, :only).permit!.to_h)
                @methods = [(@schema[:only] || []) + (@schema[:methods] || [])].flatten.compact
                @fields = @methods.collect { |method| @model_config.export.fields.select { |f| f.name == method }.first }

                field_names = @fields.collect do |field|
                  ::I18n.t('admin.export.csv.header_for_root_methods', name: field.label, model: @abstract_model.pretty_name)
                end
                response.stream.write field_names.to_csv

                query = @model_name.constantize.order(created_at: :desc).where(created_at: from..to)
                query = case @model_name
                when 'Stylist', 'RequestTourInquiry'
                  query.includes(:location)
                when 'Location'
                  query.includes(:stylists)
                else
                  query
                end

                query.find_in_batches(batch_size: 1000) do |batch|
                  joined_csv_rows = batch.map do |object|
                    @fields.collect { |field| field.with(object: object).export_value }.to_csv
                  end.join
                  response.stream.write(joined_csv_rows)
                end
              ensure
                response.stream.close
              end
            end
          end
        end
      end
    end
  end
end
