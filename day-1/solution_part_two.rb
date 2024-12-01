
def parse_number_lists_from_file(filepath)
  numbers_one = []
  numbers_two = []

  File.open(filepath, 'r') do |file|
    file.each_line do |line|
      number_one,number_two = line.split("   ").map(&:to_i)
      numbers_one.append(number_one)
      numbers_two.append(number_two)
    end
  end

  return [numbers_one, numbers_two]
end

def compute_total_similarity_score(numbers_left, numbers_right)
  num_to_freq_numbers_right = {}
  num_to_freq_numbers_right.default = 0

  # Store frequencies of each number in right list
  numbers_right.each do |number|
      num_to_freq_numbers_right[number] += 1
  end

  # Compute similarity score for each number in left list and sum
  total_similarity_score = numbers_left.reduce(0) do |total_score, number|
    number_freq = num_to_freq_numbers_right[number] || 0
    similarity_score = number * number_freq
    total_score + similarity_score
  end

  total_similarity_score
end

numbers_left, numbers_right = parse_number_lists_from_file('./input.txt')
total_similarity_score = compute_total_similarity_score(numbers_left, numbers_right)

puts total_similarity_score