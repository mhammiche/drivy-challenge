require 'date'
require_relative 'model'

class Rental < Model
  attr_accessor :id, :car_id, :start_date, :end_date, :distance, :deductible_reduction

  def rented_days
    (Date.parse(end_date) - Date.parse(start_date) + 1).ceil
  end
end
