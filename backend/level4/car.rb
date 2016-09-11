class Car
  attr_accessor :id, :price_per_day, :price_per_km

  def initialize(attributes={})
    attributes.each do |attribute, value|
      send("#{attribute}=", value)
    end
  end
end
