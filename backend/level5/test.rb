require 'minitest/autorun'
require 'json'
require_relative 'rental_service'

describe RentalService do
  before do
    data = JSON.load(File.read('./data.json'))
    @service = RentalService.new(data)
  end

  it "compute the rental price" do
    expected_output = JSON.load(File.read('./output.json'))
    @service.process_data.must_equal expected_output
  end
end
