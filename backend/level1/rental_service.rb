require "date"

class RentalService

  attr_reader :data

  def initialize(data)
    @data = data
  end

  def process_data
    {
      "rentals" => data['rentals'].map { |rental|
        process_rental(rental)
      }
    }
  end

  private

  def process_rental(rental)
    {
      "id" => rental["id"],
      "price" => calculate_price(rental)
    }
  end

  def calculate_price(rental)
    car = data["cars"].find { |c| c["id"] == rental["car_id"] }

    rental_days = (Date.parse(rental['end_date']) - Date.parse(rental['start_date']) + 1).ceil

    price_for_traveled_distance = rental["distance"] * car["price_per_km"]
    price_for_rental_duration = rental_days * car["price_per_day"]

    price_for_traveled_distance + price_for_rental_duration
  end
end
