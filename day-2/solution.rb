def process_input
  reports = []
  File.open('./input.txt', 'r') do |file|
    file.each_line do |line|
      next if line.strip.empty?
      report = line.strip.split.map(&:to_i)
      reports << report
    end
  end
  reports
end

def is_safe?(levels)
  return false if levels.length < 2
  
  differences = []
  (0...levels.length-1).each do |i|
    diff = levels[i+1] - levels[i]
    return false if diff.abs < 1 || diff.abs > 3
    differences << diff
  end
  
  all_increasing = differences.all? { |diff| diff > 0 }
  all_decreasing = differences.all? { |diff| diff < 0 }
  
  all_increasing || all_decreasing
end

def count_safe_reports(reports)
  reports.count { |report| is_safe?(report) }
end

reports = process_input
puts count_safe_reports(reports)