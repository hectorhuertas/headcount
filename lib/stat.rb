module Stat
  def self.round_decimal(number)
    if number == "N/A" || number == nil
      "N/A"
    else
    (1000.0 * number.to_f).truncate / 1000.0
    end
  end

  def self.truncating(hash)
    return "N/A" if hash.values.all?{|value| value == 'N/A'}
    hash.map do |key, value|
      if value == 'N/A'
        nil
      else
      [key, round_decimal(value)]
      end
    end.compact.to_h
  end

  def self.na_truncating(hash)
    # return "N/A÷" if hash.values.all?{|value| value == 'N/A'}
    hash.map do |key, value|
      if value == 'N/A'
        [key, "N/A"]
      else
      [key, round_decimal(value)]
      end
    end.compact.to_h
  end

  def self.nested_truncating(hash)
    return "N/A" if hash.values.all?{|value| value == 'N/A'}
    hash.map do |key, value|
      # binding.pry
      # if value.values == 'N/A'.all?
      #   [key, "N/A"]
      # else
        new_value = na_truncating(value)
        [key, new_value]
      # end

    end.compact.to_h
  end

  def self.variation(data_1, data_2)
    average(data_1) / average(data_2)
  end

  def self.average(hash)
    sum = hash.values.reduce(:+)
    count = hash.size
    sum / count
  end

  def self.compare_trends(trend_1,trend_2)
    common = trend_1.keys & trend_2.keys

    common_trend_1 ={}
    common.each {|year| common_trend_1[year]=trend_1[year]}
    common_trend_2 ={}
    common.each {|year| common_trend_2[year]=trend_2[year]}

    common_trend_1.merge(common_trend_2) do |year, av1, av2|
      round_decimal(av1/av2)
    end.sort.to_h
  end
end
