require_relative 'action'

class RentalPricing
  attr_reader :car, :rental, :discounts

  def initialize(car, rental)
    @car = car
    @rental = rental

    # @note : discount configuration, the order is important for the calculation algorithm
    @discounts = {
      10 => 0.5,
      4  => 0.3,
      1  => 0.1
    }
  end

  def actions
    [
      debit("driver", price + deductible_reduction),
      credit("owner", price - commission),
      credit("insurance", insurance_fee),
      credit("assistance", assistance_fee),
      credit("drivy", drivy_fee + deductible_reduction)
    ]
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

  def deductible_reduction
    if rental.deductible_reduction
      rental.rented_days * 400
    else
      0
    end
  end

  private

  def credit(who, amount)
    Action.new(who, "credit", amount)
  end

  def debit(who, amount)
    Action.new(who, "debit", amount)
  end

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
