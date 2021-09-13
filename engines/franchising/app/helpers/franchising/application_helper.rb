module Franchising
  module ApplicationHelper
    def canadian_states_options
      [
        'Alberta', 'British Columbia', 'Manitoba', 'New Brunswick', 'Newfoundland and Labrador',
        'Northwest Territories', 'Nova Scotia', 'Nunavut', 'Ontario', 'Prince Edward Island',
        'Quebec', 'Saskatchewan', 'Yukon'
      ].map { |name| content_tag :option, name, value: name }.join('').html_safe
    end
  end
end
