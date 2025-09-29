# frozen_string_literal: true

require 'date'
require_relative 'project'
require_relative 'pay_scales'

# This class will, given an array of projects, calculate the expected reimbursment type and value
# for each day covered by all projects as well as a total for reimbursment.
class Reimbursement
  attr_reader :by_date, :total

  def initialize(projects) 
    validate_projects(projects)

    @projects = projects
    @by_date = {}
    @total = 0

    process
  end

  private 

  def validate_projects(projects)
    raise InvalidProjects unless (projects.all? { |p| p.is_a?(Project) } rescue false)
  end

  def process
    process_all_projects
    calculate_total
  end

  def process_all_projects
    @projects.each { |project| process_project(project) }
  end

  def process_project(project)
    project.date_range.each { |date| process_date(date, project.pay_scale) }
  end

  def process_date(date, scale)
    @by_date[date] = { scale: comapre_scales(@by_date[date]&.dig(:scale), scale) }
  end

  def comapre_scales(a, b)
    [a, b].include?(PayScales::HIGH) ? PayScales::HIGH : PayScales::LOW    
  end

  def calculate_total
    dates = by_date.keys

    dates.each do |date|
      day_type = travel_day?(date) ? PayScales::TRAVEL_DAY : PayScales::FULL_DAY
      value = PayScales::VALUES[by_date[date][:scale]][day_type]

      # stash calculated values for debugging 
      by_date[date][:day_type] = day_type
      by_date[date][:value] = value

      @total += value
    end
  end

  def travel_day?(date)
    [by_date[date.prev_day], by_date[date.next_day]].include?(nil) 
  end

  class ArgumentError < RuntimeError
    def message
      "Invalid argument(s)."
    end
  end

  class InvalidProjects < ArgumentError
    def message
      "An array of projects is required."
    end
  end
end
