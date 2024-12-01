
def compute_total_distance(list_one, list_two)
  num_locations = list_one.count
  total_distance = 0

  num_locations.times do |i|
    location_one = list_one[i]
    location_two = list_two[i]

    distance = (location_one - location_two).abs
    total_distance += distance
  end

  total_distance
end

def parse_location_lists_from_file(filepath)
  locations_one = []
  locations_two = []

  File.open(filepath, 'r') do |file|
    file.each_line do |line|
      location_one,location_two = line.split("   ").map(&:to_i)
      locations_one.append(location_one)
      locations_two.append(location_two)
    end
  end

  return [locations_one, locations_two]
end

locations_one, locations_two = parse_location_lists_from_file('./input.txt')
locations_one.sort!
locations_two.sort!

puts compute_total_distance(locations_one, locations_two)