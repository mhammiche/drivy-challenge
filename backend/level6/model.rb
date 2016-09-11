class Model
  def initialize(attrs={})
    load_attributes(attrs)
  end

  private

  def load_attributes(attrs)
    attrs.each do |attribute, value|
      send("#{attribute}=", value)
    end
  end
end
