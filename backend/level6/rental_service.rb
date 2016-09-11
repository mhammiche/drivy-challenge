require_relative 'car'
require_relative 'rental'
require_relative 'rental_modification'
require_relative 'rental_pricing'

class RentalService

  attr_reader :data, :cars, :rentals, :rental_modifications

  def initialize(data)
    @cars = data['cars'].map { |c| Car.new(c) }
    @rentals = data['rentals'].map { |r| Rental.new(r) }
    @rental_modifications = data['rental_modifications'].map { |m| RentalModification.new(m) }
  end

  def process_data
    {
      "rental_modifications" => rental_modifications.map do |rental_modification|
        process_rental(rental_modification)
      end
    }
  end

  private

  def process_rental(rental_modification)
    rental = find_rental(rental_modification.rental_id)
    updated_rental = update_rental(rental, rental_modification)
    car = find_car(rental.car_id)
    pricing = RentalPricing.new(car, rental)
    updated_pricing = RentalPricing.new(car, updated_rental)

    actions = compute_actions_delta(pricing.actions, updated_pricing.actions)

    {
      "id" => rental_modification.id,
      "rental_id" => rental.id,
      "actions" => actions.map do |action|
        {
          "who" => action.who,
          "type" => action.type,
          "amount" => action.amount
        }
      end
    }
  end

  def update_rental(rental, rental_modification)
    Rental.new({
      "id" => rental.id,
      "car_id" => rental.car_id,
      "start_date" => (rental_modification.start_date || rental.start_date),
      "end_date" => (rental_modification.end_date || rental.end_date),
      "distance" => (rental_modification.distance || rental.distance),
      "deductible_reduction" => rental.deductible_reduction
    })
  end

  # @note : It assume the actions list are ordered in the same way
  def compute_actions_delta(actions, updated_actions)
    actions.zip(updated_actions).map { |old, new| old.delta(new) }
  end

  def find_car(id)
    cars.find { |c| c.id == id }
  end

  def find_rental(id)
    rentals.find { |r| r.id == id }
  end
end
