require "date"
require_relative 'car'
require_relative 'rental'
require_relative 'rental_pricing'

class RentalService

  attr_reader :data, :cars, :rentals

  def initialize(data)
    @cars = data['cars'].map { |c| Car.new(c) }
    @rentals = data['rentals'].map { |r| Rental.new(r) }
  end

  def process_data
    {
      "rentals" => rentals.map { |rental| process_rental(rental) }
    }
  end

  private

  def process_rental(rental)
    car = find_car_by_id(rental.car_id)
    rental_pricing = RentalPricing.new(car, rental)
    {
      "id" => rental.id,
      "price" => rental_pricing.price,
      "commission" => {
        "insurance_fee" => rental_pricing.insurance_fee,
        "assistance_fee" => rental_pricing.assistance_fee,
        "drivy_fee" => rental_pricing.drivy_fee
      }
    }
  end

  def find_car_by_id(id)
    cars.find { |c| c.id == id }
  end
end
