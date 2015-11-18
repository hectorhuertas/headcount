require 'csv'
require 'pry'

module Parser
  def self.enrollment(data)
    parsed_data = data.keys.reduce({}) do |result, filetype|
      new_data = send(filetype, data[filetype])
      result.merge(new_data) { |_k, v1, v2| v1.merge v2 }
    end
    wrap_name(parsed_data)
  end

  def self.kindergarten((filename))
    lines = CSV.open(filename, headers: true, header_converters: :symbol).map do |row|
      frame_work(row)
    end.compact

    raw_data = merge(lines)
    wrap(raw_data, :kindergarten_participation)
  end

  def self.high_school_graduation(filename)
    lines = CSV.open(filename, headers: true, header_converters: :symbol).map do |row|
      frame_work(row)
    end.compact

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

  def self.is_not_a_number?(string)
    string.start_with?("#", "N")
  end

  def self.frame_work(row)
    if is_not_a_number?(row[:data])
      nil
    else
      { row[:location].upcase => { row[:timeframe].to_i => row[:data].to_f } }
    end
  end
end
