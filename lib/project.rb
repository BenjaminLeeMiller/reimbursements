# frozen_string_literal: true

require 'date'
require_relative 'pay_scales'

# This class represents a single project's characteristics
class Project
  attr_reader :start_date, :end_date, :pay_scale

  VALID_PAY_SCALE_VALUES = [PayScales::HIGH, PayScales::LOW]

  def initialize(start_date, end_date, pay_scale)
    validate_date_range(start_date, end_date)
    validate_scale(pay_scale)

    @start_date = start_date
    @end_date = end_date
    @pay_scale = pay_scale
  end

  def date_range
    start_date..end_date
  end
  
  private

  def validate_date_range(start_date, end_date)
    raise(InvalidStartDate) unless start_date.is_a?(Date)
    raise(InvalidEndDate) unless end_date.is_a?(Date)
    raise(InvalidDateRange) unless start_date <= end_date
  end

  def validate_scale(scale)
    raise(InvalidScale) unless VALID_PAY_SCALE_VALUES.include?(scale)
  end

  class ArgumentError < RuntimeError
    def message
      "Invalid argument(s)."
    end
  end

  class InvalidStartDate < ArgumentError
    def message
      "The specified start date is invalid."
    end
  end

  class InvalidEndDate < ArgumentError
    def message
      "The specified end date is invalid."
    end
  end

  class InvalidDateRange < ArgumentError
    def message
      "The end date must be the same or greater than the start date."
    end
  end

  class InvalidScale < ArgumentError
    def message
      "The specified pay scale is invalid.  Valid values: [#{VALID_PAY_SCALE_VALUES.join(', ')}]."
    end
  end
end