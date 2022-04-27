# frozen_string_literal: true

module Franchising
  module ApplicationHelper
    def state_options_for_select
      if canadian_locale?
        canadian_state_options
      else
        usa_state_options
      end
    end

    def prompt_option
      content_tag(:option, t('franchising.website.franchise_form.selector_prompt'), selected: true, value: '')
    end

    def canadian_state_options
      result = CA_STATES.values.map { |name| content_tag :option, name, value: name }.join.html_safe

      [prompt_option, result].join.html_safe
    end

    def usa_state_options
      result = USA_STATES.values.map { |name| content_tag :option, name, value: name }.join.html_safe

      [prompt_option, result].join.html_safe
    end
  end
end
