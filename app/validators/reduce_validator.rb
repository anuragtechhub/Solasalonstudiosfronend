# frozen_string_literal: true

class ReduceValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, _value)
    return until record.errors.messages.key?(attribute)
    record.errors[attribute].slice!(-1) until record.errors[attribute].size <= 1
  end
end
