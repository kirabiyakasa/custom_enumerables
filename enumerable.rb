require 'pry'

module Enumerable

  def my_each()
    n = self.length
    i = 0
    until i == n do
      yield self[i]
      i += 1
    end
  end

  def my_each_with_index()
    n = self.length
    i = 0
    until i == n do
      yield self[i], i
      i += 1
    end
  end

  def my_select()
    new_array = []

    if block_given?
      self.my_each do |num|
        match = yield num
        if match
          new_array << num
        end
      end
    else
      return self.to_enum(:my_select)
    end
    return new_array
  end

  def my_all?(*args)
    if args.length > 0
      puts "#{__FILE__}:#{caller[0].scan(/\d+/).first}: " +
           "warning: given block not used" if block_given?
      return false unless self.my_all? { |item| args[0] === item }
    elsif block_given?
      self.my_each do |item|
        return false unless yield item
      end
    else
      return false unless self.my_all? { |item| item }
    end
    return true
  end

  def my_any?(*args)
    if args.length > 0
      puts "#{__FILE__}:#{caller[0].scan(/\d+/).first}: " +
      "warning: given block not used" if block_given?
      return true if self.my_any? { |item| args[0] === item }
    elsif block_given?
      self.my_each do |item|
        return true if yield item
      end
    else
      return true if self.my_any? { |item| item }
    end
    return false
  end

  def my_none?(*args)
    if args.length > 0
      puts "#{__FILE__}:#{caller[0].scan(/\d+/).first}: " +
      "warning: given block not used" if block_given?
      return false if self.my_none? { |item| args[0] === item }
    elsif block_given?
      self.my_each do |item|
        return false if yield item
      end
    else
      return false unless self.my_none? { |item| item }
    end
    return true
  end

  def my_count(*args)
    num = 0
    if args.length > 0
      num = self.my_count { |item| args[0] === item }
    elsif block_given?
      self.my_each do |item|
        num += 1 if yield item
      end
    else
      num = self.my_count { |item| Object === item }
    end
    return num
  end

  def my_map()
    new_array = []
    if block_given?
      self.my_each do |item|
        new_item = yield item
        new_array << new_item
      end
      return new_array
    end
    return self.to_enum(:my_map)
  end

  def my_inject(*args)
    raise "big error" if args.length > 1
    collection = self.to_a if Range === self
    collection = self if Array === self

    Numeric === args[0] ? accumulator = args[0] : accumulator = collection[0]

    if block_given?
      collection.my_each_with_index do |item, i|
        next if (Numeric === args[0]) == false && i == 0
        accumulator = yield accumulator, item if Array === collection
      end
    else
      raise "no block given"
    end
    return accumulator
  end

end

def multiply_els(array)
  product = array.my_inject { |product, n| product * n }
  return product
end

puts "my_each vs. each"
numbers = [1, 2, 3, 4, 5]
numbers.my_each { |item| puts item }
numbers.each  { |item| puts item }

puts "\nmy_each_with_index vs. each_with_index"
numbers.my_each_with_index { |item, i| puts "index of #{item} is #{i}" }
numbers.each_with_index  { |item, i| puts "index of #{item} is #{i}" }

puts "\nmy_select vs select"
puts "with a block:"
p numbers.my_select { |num| num.even? }
p numbers.select { |num| num.even? }
puts "without a block:"
p numbers.my_select
p numbers.select

puts "\nmy_all? vs all?"
puts "Block not given:"
puts numbers.my_all?(Integer)
puts numbers.all?(Integer)
puts [nil, nil].my_all?()
puts [nil, nil].all?()
puts "Block given:"
puts numbers.my_all?() { |num| num > 0 }
puts numbers.all?() { |num| num > 0 }

puts "\nmy_any? vs any?"
puts numbers.my_any? { |num| num == 0 }
puts numbers.any? { |num| num == 0 }

puts "\nmy_none? vs none?"
puts "Block given:"
puts %w{ant bear cat}.my_none? { |word| word.length >= 4 }
puts %w{ant bear cat}.none? { |word| word.length >= 4 }
puts "Block not given:"
puts [1, 3, 42].none?(Float)
puts [1, 3, 42].none?(Float)
puts numbers.my_none?
puts numbers.none?

puts "\nmy_count vs count"
puts "Block not given:"
puts numbers.my_count
puts numbers.count
puts numbers.my_count(2)
puts numbers.count(2)
puts "Block given:"
puts numbers.my_count { |num| num > 3 }
puts numbers.count { |num| num > 3 }

puts "\nmy_map vs map"
puts "Block given:"
p numbers.my_map { |num| num * num }
p numbers.map { |num| num * num }
puts "With a proc:"
multiply_nums = Proc.new { |num| num * num }
p numbers.my_map(&multiply_nums)
puts "Block not given:"
p numbers.my_map
p numbers.map

puts "\nmy_insert vs insert"
puts "Block given:"
puts (5..10).inject { |sum, n| sum + n }
puts (5..10).my_inject { |sum, n| sum + n }
puts numbers.my_inject { |product, n| product * n }
puts multiply_els(numbers)
