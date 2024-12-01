
def parse_number_lists_from_file(filepath)
  numbers_one = []
  numbers_two = []

  File.open(filepath, 'r') do |file|
    file.each_line do |line|
      location_one,location_two = line.split("   ").map(&:to_i)
      numbers_one.append(location_one)
      numbers_two.append(location_two)
    end
  end

  return [numbers_one, numbers_two]
end

def compute_total_similarity_score(list_one, list_two)
  num_to_freq_list_two = {}

  list_two.each do |number|
      if num_to_freq_list_two.key?(number)
        num_to_freq_list_two[number] += 1
      else 
        num_to_freq_list_two[number] = 1
      end
  end

  total_similarity_score = 0

  list_one.each do |number|
    number_freq = num_to_freq_list_two.key?(number) ? num_to_freq_list_two[number] : 0
    similarity_score = number * number_freq
    total_similarity_score += similarity_score
  end

  total_similarity_score
end


numbers_one, numbers_two = parse_number_lists_from_file('./input.txt')
total_similarity_score = compute_total_similarity_score(numbers_one, numbers_two)
puts total_similarity_score