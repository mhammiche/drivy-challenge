require_relative 'model'

class RentalModification < Model
  attr_accessor :id, :rental_id, :start_date, :end_date, :distance
end
