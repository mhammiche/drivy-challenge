require "date"
require_relative 'car'
require_relative 'rental'

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
    {
      "id" => rental.id,
      "price" => calculate_price(rental)
    }
  end

  def calculate_price(rental)
    car = find_car_by_id(rental.car_id)

    price_for_traveled_distance(rental.distance, car.price_per_km) +
      price_for_rental_duration(rental.rented_days, car.price_per_day)
  end

  def price_for_traveled_distance(distance, price_per_km)
    distance * price_per_km
  end

  def price_for_rental_duration(days, price_per_day)
    discounts = {
      10 => 0.5,
      4  => 0.3,
      1  => 0.1
    }

    price = price_per_day
    discounts.each do |nday, discount|
      if days > nday
        discount_price = (price_per_day * (1 - discount)).ceil
        price = price + (days - nday) * discount_price
        days = nday
      end
    end

    price
  end

  def find_car_by_id(id)
    cars.find { |c| c.id == id }
  end
end
