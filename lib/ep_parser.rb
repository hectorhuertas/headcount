module EpParser
  def self.profiles(data)
    e = median_household_income(data[:median_household_income]) if data[:median_household_income]
    binding.pry
    wrap_name(e)
  end

  def self.median_household_income(filename)
    lines = CSV.open(filename, headers: true, header_converters: :symbol).map do |row|
      if not_a_number?(row[:data])
        nil
      else
        { row[:location].upcase => { range(row[:timeframe]) => row[:data].to_f } }
      end
    end.compact
    raw_data = merge(lines)
    wrap(raw_data, :median_household_income)
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

  def self.wrap(raw_data, key_info)
    raw_data.reduce({}) { |result, (k, v)| result[k] = { key_info => v }; result }
  end

  def self.wrap_name(hash)
    c = hash.map { |k, v| { name: k }.merge v }
  end
end
