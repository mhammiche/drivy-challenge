class RentalPricing
  attr_reader :car, :rental, :discounts

  def initialize(car, rental)
    @car = car
    @rental = rental
    @discounts = {
      10 => 0.5,
      4  => 0.3,
      1  => 0.1
    }
  end

  def price
    @price ||= (price_for_traveled_distance + price_for_rental_duration)
  end

  def commission
    (price * 0.3).ceil
  end

  def insurance_fee
    commission / 2
  end

  def assistance_fee
    rental.rented_days * 100
  end

  def drivy_fee
    commission - insurance_fee - assistance_fee
  end

  private

  def price_for_traveled_distance
    rental.distance * car.price_per_km
  end

  def price_for_rental_duration
    days = rental.rented_days
    price = car.price_per_day
    discounts.each do |nday, discount|
      if days > nday
        discount_price = (car.price_per_day * (1 - discount)).ceil
        price = price + (days - nday) * discount_price
        days = nday
      end
    end

    price
  end
end
