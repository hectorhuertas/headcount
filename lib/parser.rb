require 'csv'
require 'pry'
module Parser

  # def self.get_names(filename)
  #   file = CSV.open(filename, headers: true, header_converters: :symbol)
  #   names = file.map do |line|
  #     line[:location]
  #   end
  #   names.uniq
  # end

  def self.parse(data)
    # send(:enrollment, data[:enrollment])
    # binding.pry
    e = enrollment(data[:enrollment])
    # binding.pry
    [e]
  end

  def self.merge_hashes(array, key_info)
    names = array.map{|line| line[:name]}.uniq
    names.reduce([]) do |result, name|
      # binding.pry
      a = array.find_all{|line| line[:name]== name}
      b = a.reduce({}) do |result, line|
        result.merge(line[key_info])
      end
      # binding.pry
      result<< {name: name, key_info => b}
    end

    # array.reduce([]) do |hash|
    #   names.map do |name|
    #
    #   end
    #   if result.empty?  || result.last[:name] == !hash[:name]
    #     result << hash
    #   end
    #   binding.pry
    # end
    # array.reduce([]) do |result, hash|
    #   # binding.pry
    #   if result.empty? || result[-1][:name] == !hash[:name]
    #     result << hash
    #   else
    #     # binding.pry
    #     result[-1] = result[-1][key_info].merge(hash[key_info])
    #     # merge_info(result, hash, key_info)
    #     # result << pop.push(result)
    #     puts result
    #     result
    #   end
    # end
  end

  def self.merge_info(result, hash, key_info)
    result.last[key_info] = result.last[key_info].merge(hash[key_info])
    result
  end

  def self.kindergarten2(filename)
    lines = CSV.open(filename, headers: true, header_converters: :symbol).map do |row|
      {:name => row[:location].upcase, :kindergarten_participation => {row[:timeframe].to_i => row[:data].to_f.round(3)} }
    end
    # binding.pry
    merge_hashes(lines, :kindergarten_participation)
  end

  def self.high_school_graduation(filename)
    lines = CSV.open(filename, headers: true, header_converters: :symbol).map do |row|
      {:name => row[:location].upcase, :high_school_graduation => {row[:timeframe].to_i => row[:data].to_f.round(3)} }
    end
    merge_hashes(lines, :high_school_graduation)
    # binding.pry
  end

  def self.enrollment(data)
    # binding.pry
     b = data.keys.map do |filetype|
    send(filetype, data[filetype])
  end
  # binding.pry
  end

  def self.kindergarten((filename))
    lines = CSV.open(filename, headers: true, header_converters: :symbol).map do |row|
      {row[:location].upcase => {row[:timeframe].to_i => row[:data].to_f.round(3)} }
    end
    # binding.pry
    # merge_lines(lines)
     bob = lines.reduce({}){|result, line| result.merge(line){|k,v1,v2|v1.merge v2}}
     bob.map{|k,v| {name: k, :kindergarten_participation =>v}}
  end

  def self.merge_lines(lines)
    lines.reduce({})
  end

end
