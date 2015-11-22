module EpParser
  def self.profiles(data)
    array = []
    array << median_household_income(data[:median_household_income]) if data[:median_household_income]
    array << children_in_poverty(data[:children_in_poverty]) if data[:children_in_poverty]
    array << lunch_help(data[:free_or_reduced_price_lunch]) if data[:free_or_reduced_price_lunch]
    array << title_i(data[:title_i]) if data[:title_i]
    e = array.reduce do |result, hash|
      result.merge(hash){|k,v1,v2|v1.merge(v2)}
    end
    # binding.pry
    wrap_name(e)
  end

  def self.median_household_income(filename)
    lines = CSV.open(filename, headers: true, header_converters: :symbol).map do |row|
      if row[:data].nil? || not_a_number?(row[:data])
        { row[:location].upcase => { range(row[:timeframe]) => 'N/A' } }
      else
        { row[:location].upcase => { range(row[:timeframe]) => row[:data].to_f } }
      end
    end.compact
    raw_data = merge(lines)
    wrap(raw_data, :median_household_income)
  end

  def self.children_in_poverty(filename)
    lines = CSV.open(filename, headers: true, header_converters: :symbol).map do |row|
      if row[:dataformat] == "Percent"
        if row[:data].nil? || not_a_number?(row[:data])
          { row[:location].upcase => { row[:timeframe].to_i => 'N/A' } }
        else
          { row[:location].upcase => { row[:timeframe].to_i => row[:data].to_f } }
        end
      end
    end.compact
    raw_data = merge(lines)
    wrap(raw_data, :children_in_poverty)
  end

  def self.title_i(filename)
    lines = CSV.open(filename, headers: true, header_converters: :symbol).map do |row|
      if row[:dataformat] == "Percent"
        if not_a_number?(row[:data])
          { row[:location].upcase => { row[:timeframe].to_i => 'N/A' } }
        else
          { row[:location].upcase => { row[:timeframe].to_i => row[:data].to_f } }
        end
      end
    end.compact
    raw_data = merge(lines)
    # binding.pry
    wrap(raw_data, :title_i)
  end

  def self.lunch_help(filename)
    lines = CSV.open(filename, headers: true, header_converters: :symbol).map do |row|
      if row[:poverty_level] == "Eligible for Free or Reduced Lunch"
        if row[:dataformat] == "Percent"
          if not_a_number?(row[:data])
            { row[:location].upcase => { row[:timeframe].to_i => { :percentage => 'N/A' } } }
          else
            { row[:location].upcase => { row[:timeframe].to_i => { :percentage => row[:data].to_f } } }
          end
        else
          if not_a_number?(row[:data])
            { row[:location].upcase => { row[:timeframe].to_i => { :total => 'N/A' } } }
          else
            { row[:location].upcase => { row[:timeframe].to_i => { :total => row[:data].to_i } } }
          end
        end
      end
    end.compact
    raw_data = merge_deep(lines)
      # binding.pry
    wrap(raw_data, :free_or_reduced_price_lunch)
  end

  def self.not_a_number?(string)
    string.start_with?('D', 'L', 'N')
  end

  def self.range(string)
    string.split('-').map(&:to_i)
  end

  def self.merge(lines)
    lines.reduce do |result, line|
      result.merge(line) { |_k, v1, v2| v1.merge(v2) }
    end
  end

  def self.merge_deep(lines)
    lines.reduce{|result,line| result.merge(line){|k,v1,v2|
      v1.merge(v2){|k,v1,v2| v1.merge v2}
      }}
  end

  def self.wrap(raw_data, key_info)
    raw_data.reduce({}) { |result, (k, v)| result[k] = { key_info => v }; result }
  end

  def self.wrap_name(hash)
    c = hash.map { |k, v| { name: k }.merge v }
  end
end
