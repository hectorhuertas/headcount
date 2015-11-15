require 'csv'
require 'pry'
module Parser
  def self.enrollment(data)
    parsed_data = data.keys.reduce({}) do |result, filetype|
      new_data = send(filetype, data[filetype])
      result.merge(new_data) { |_k, v1, v2| v1.merge v2 }
    end
    wrap_name(wrap(parsed_data, :enrollment))
  end

  def self.kindergarten((filename))
    lines = CSV.open(filename, headers: true, header_converters: :symbol).map do |row|
      { row[:location].upcase => { row[:timeframe].to_i => row[:data].to_f.round(3) } }
    end
    raw_data = merge(lines)
    wrap(raw_data, :kindergarten_participation)
  end

  def self.high_school_graduation(filename)
    lines = CSV.open(filename, headers: true, header_converters: :symbol).map do |row|
      { row[:location].upcase => { row[:timeframe].to_i => row[:data].to_f.round(3) } }
    end
    raw_data = merge(lines)
    wrap(raw_data, :high_school_graduation)
  end

  def self.merge(lines)
    lines.reduce({}) { |result, line| result.merge(line) { |_k, v1, v2| v1.merge v2 } }
  end

  def self.wrap(raw_data, key_info)
    raw_data.reduce({}) { |result, (k, v)| result[k] = { key_info => v }; result }
  end

  def self.wrap_name(hash)
    c = hash.map { |k, v| { name: k }.merge v }
  end
end
