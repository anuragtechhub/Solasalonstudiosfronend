module Franchising
  module ApplicationHelper
    def state_options_for_select()
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
      result = [
        'Alberta', 'British Columbia', 'Manitoba', 'New Brunswick', 'Newfoundland and Labrador',
        'Northwest Territories', 'Nova Scotia', 'Nunavut', 'Ontario', 'Prince Edward Island',
        'Quebec', 'Saskatchewan', 'Yukon'
      ].map { |name| content_tag :option, name, value: name }.join('').html_safe

      [prompt_option, result].join('').html_safe
    end

    def usa_state_options
      result = [
        'Alabama', 'Alaska', 'Arizona', 'Arkansas', 'California', 'Colorado', 'Connecticut',
        'Delaware', 'District of Columbia', 'Florida', 'Georgia', 'Hawaii', 'Idaho', 'Illinois',
        'Indiana', 'Iowa', 'Kansas', 'Kentucky', 'Louisiana', 'Maine', 'Maryland', 'Massachusetts',
        'Michigan', 'Minnesota', 'Mississippi', 'Missouri', 'Montana', 'Nebraska', 'Nevada',
        'New Hampshire', 'New Jersey', 'New Mexico', 'New York', 'North Carolina', 'North Dakota',
        'Ohio', 'Oklahoma', 'Oregon', 'Pennsylvania', 'Rhode Island', 'South Carolina', 'South Dakota',
        'Tennessee', 'Texas', 'Utah', 'Vermont', 'Virginia', 'Washington', 'West Virginia', 'Wisconsin',
        'Wyoming'
      ].map { |name| content_tag :option, name, value: name }.join('').html_safe

      [prompt_option, result].join('').html_safe
    end
  end
end
