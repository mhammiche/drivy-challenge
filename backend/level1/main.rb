require "json"
require_relative "rental_service"

# your code

data = JSON.load(File.read('./data.json'))

service = RentalService.new(data)

output = service.process_data

File.write('./output2.json', JSON.pretty_generate(output))
