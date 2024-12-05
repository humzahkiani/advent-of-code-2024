require 'set'

def process_input 
  File.open('./input.txt', 'r') do |file|
    is_updates_section = false
    page_to_ordered_before_pages = Hash.new { |hash, key| hash[key] = [] }
    updates = []
    file.each_line do |line|
      if line.strip.empty?
        is_updates_section = true 
        next
      end
      if !is_updates_section
        page_before, page_after = line.strip.split("|")
        page_to_ordered_before_pages[page_after].append(page_before)
      else
         update = line.strip.split(",").map(&:to_i)
         updates << update
      end 
    end
    return page_to_ordered_before_pages, updates
  end
end

def find_valid_updates(page_to_ordered_before_pages, updates)
  valid_updates = []
  updates.each do |update|
    is_valid = true 
    update.each_with_index do |page, index|
      next unless page_to_ordered_before_pages.has_key?(page.to_s)
      
      before_pages = page_to_ordered_before_pages[page.to_s]
      ((index + 1)...update.length).each do |j|
        after_page = update[j]
        if before_pages.include?(after_page.to_s)
          is_valid = false 
          break
        end
      end
      break unless is_valid
    end
    valid_updates << update if is_valid
  end
  return valid_updates
end

def compute_updates_sum(updates)
  updates.reduce(0) do |sum, update|
    length = update.length
    middle_i = (length.div(2)).to_i
    sum += update[middle_i]
  end
end

def fix_invalid_updates(updates, page_to_ordered_before_pages)
  fixed_updates = []
  
  updates.each do |update|
    # Create a hash of dependencies for each page
    dependencies = {}
    update.each do |page|
      dependencies[page] = Set.new
      update.each do |other_page|
        if page_to_ordered_before_pages[page.to_s]&.include?(other_page.to_s)
          dependencies[page].add(other_page)
        end
      end
    end
    
    # Topological sort
    result = []
    visited = Set.new
    temp = Set.new
    
    def visit(node, dependencies, visited, temp, result)
      return false if temp.include?(node)
      return true if visited.include?(node)
      
      temp.add(node)
      dependencies[node].each do |dep|
        return false unless visit(dep, dependencies, visited, temp, result)
      end
      temp.delete(node)
      visited.add(node)
      result.unshift(node)
      true
    end
    
    # Process each node
    update.each do |page|
      next if visited.include?(page)
      visit(page, dependencies, visited, temp, result)
    end
    
    fixed_updates << result
  end
  
  fixed_updates
end

# Part 1
page_to_ordered_before_pages, updates = process_input
valid_updates = find_valid_updates(page_to_ordered_before_pages, updates)
sum = compute_updates_sum(valid_updates)
puts "Part 1: #{sum}"

# Part 2
invalid_updates = updates - valid_updates
fixed_updates = fix_invalid_updates(invalid_updates, page_to_ordered_before_pages)
fixed_sum = compute_updates_sum(fixed_updates)
puts "Part 2: #{fixed_sum}"