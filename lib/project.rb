# frozen_string_literal: true

require 'date'
require_relative 'costs'

# This class represents a single project's characteristics
class Project
  attr_reader :start_date, :end_date, :cost

  VALID_COST_VALUES = [Costs::HIGH, Costs::LOW]

  def initialize(start_date, end_date, cost)
    validate_date_range(start_date, end_date)
    validate_cost(cost)

    @start_date = start_date
    @end_date = end_date
    @cost = cost
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

  def validate_cost(cost)
    raise(InvalidCost) unless VALID_COST_VALUES.include?(cost)
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

  class InvalidCost < ArgumentError
    def message
      "The specified cost is invalid.  Valid values: [#{VALID_COST_VALUES.join(', ')}]."
    end
  end
end