# frozen_string_literal: true

####### html renderer #######

class HTMLRenderer
  include RenderAnywhere

  def build_html(template = 'reports/test', locals = {})
    render template: template,
           layout:   'reports',
           locals:   locals
  end

  # Include an additional helper
  # If being used in a rake task, you may need to require the file(s)
  # Ex: require Rails.root.join('app', 'helpers', 'blog_pages_helper')
  def include_helper(helper_name)
    set_render_anywhere_helpers(helper_name)
  end

  # Apply an instance variable to the controller
  # If you need to use instance variables instead of locals, just call this method as many times as you need.
  def set_instance_variable(var, value)
    set_instance_variable(var, value)
  end

  class RenderingController < RenderAnywhere::RenderingController
    # # include custom modules here, define accessors, etc. For example:
    # attr_accessor :current_user
    # helper_method :current_user
  end

  # If you define custom RenderingController, don't forget to override this method
  def rendering_controller
    @rendering_controller ||= self.class.const_get('RenderingController').new
  end
end
