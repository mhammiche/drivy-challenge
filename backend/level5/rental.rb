require 'date'

class Rental
  attr_accessor :id, :car_id, :start_date, :end_date, :distance, :deductible_reduction

  def initialize(attributes={})
    attributes.each do |attribute, value|
      send("#{attribute}=", value)
    end
  end

  def rented_days
    (Date.parse(end_date) - Date.parse(start_date) + 1).ceil
  end
end
