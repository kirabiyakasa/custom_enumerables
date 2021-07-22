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
