require 'csv'
require 'pry-rescue'

module StParser

  # def self.merge(lines)
  #   lines = merge_year_data(lines)
  #   # binding.pry
  #   # lines.reduce({}) { |result, line| result.merge(line) { |_k, v1, v2| v1.merge v2 } }
  # end



  #
  def self.wrap(raw_data, key_info)
    raw_data.reduce({}) { |result, (k, v)| result[k] = { key_info => v }; result }
  end
  #
  def self.wrap_name(hash)
    c = hash.map { |k, v| { name: k }.merge v }
  end
  #
  # def self.is_not_a_number?(string)
  #   string.start_with?("#", "N")
  # end
  #
  # def self.frame_work(row)
  #   if is_not_a_number?(row[:data])
  #     nil
  #   else
  #     { row[:location].upcase => { row[:timeframe].to_i => row[:data].to_f.round(3) } }
  #   end
  # end

  def self.st_test(data)
    third_grade = third_grade(data[:third_grade], :third_grade)
    eighth_grade = eighth_grade(data[:eighth_grade], :eighth_grade)
    proficiency = avg_proficiency({math: data[:math], reading: data[:reading], writing: data[:writing]})
    e =[third_grade, eighth_grade, proficiency].reduce do |result, hash|
      result.merge(hash){|k,v1,v2|v1.merge(v2)}
    end
    wrap_name(e)
  end

  def self.third_grade(filename, filetype)
    data = third_and_eighth_grade(filename)
    wrap(data, filetype)
  end

  def self.eighth_grade(filename, filetype)
    data = third_and_eighth_grade(filename)
    wrap(data, filetype)
  end

  def self.avg_proficiency(data)
    math = race(data[:math], :math)
    reading = race(data[:reading], :reading)
    writing = race(data[:writing], :writing)
    e = [math,reading,writing].reduce{|result,hash|
    merge_deeper(result,hash)}
    # binding.pry
  end

  def self.third_and_eighth_grade(filename)
    lines = CSV.open(filename, headers: true, header_converters: :symbol).map do |row|
      # binding.pry
      {row[:location].upcase => {row[:timeframe].to_i => {row[:score].downcase.to_sym => row[:data].to_f.round(3)}}}
    end.compact
    raw_data = merge_deep(lines)
  end

  def self.race(filename, filetype)
    lines = CSV.open(filename, headers: true, header_converters: :symbol).map do |row|
      {row[:location].upcase => {row[:race_ethnicity].to_sym => {row[:timeframe].to_i =>{ filetype => row[:data].to_f.round(3)}}}}
    end.compact
    raw_data = merge_years(lines)
    # binding.pry
  end

  def self.merge_deep(lines)
    lines.reduce{|result,line| result.merge(line){|k,v1,v2|
      v1.merge(v2){|k,v1,v2| v1.merge v2}
      }}
  end

  def self.merge_years(lines)
    lines.reduce{|result,line| result.merge(line){|k,v1,v2|
      v1.merge(v2){|k,v1,v2| v1.merge(v2){|k,v1,v2|
        # binding.pry
        v1.merge(v2)
        }}
      }}
  end

  def self.merge_deeper(h1,h2)
    h1.merge(h2){|k,v1,v2|
       v1.merge(v2){|k,v1,v2|
         v1.merge(v2){|k,v1,v2|
           v1.merge(v2)}}}
  end
end
