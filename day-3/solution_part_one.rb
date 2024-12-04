
def process_input
  File.read('./input.txt').gsub(" ", "")
end

def find_valid_pairs(data)
  patterns = data.scan(/mul\((\d+),(\d+)\)/)
  pairs = patterns.map do |match|
    [match[0].to_i, match[1].to_i]
  end
  pairs
end

def find_substrings(data)
  substrings = []
  
  data.to_enum(:scan, /do\(\)(.*?)don't\(\)/m).each do |_|
    match = Regexp.last_match
    substrings << match[0]
  end
  
  if first_dont = data.match(/\A(.*?don't\(\))/m)
    substrings << first_dont[0]
  end
  
  last_dont_pos = data.rindex("don't()")
  last_do_pos = data.rindex("do()")
  
  if last_do_pos && (last_dont_pos.nil? || last_do_pos > last_dont_pos)
    substrings << data[last_do_pos..-1]
  end
  
  substrings
end


def calculate_total(pairs)
    pairs.reduce(0) do |total, pair|
      int_one, int_two = pair[0],pair[1]
      total + (int_one*int_two)
    end
end

data = process_input
substrings = find_substrings(data)
pairs = find_valid_pairs(data)

part_one_total = calculate_total(pairs)

part_two_total = substrings.reduce(0) do |total, substring|
  pairs = find_valid_pairs(substring)
  total + calculate_total(pairs)
end

puts part_one_total
puts part_two_total