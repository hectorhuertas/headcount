module Stat
  def self.round_decimal(number)
    if number == "N/A"
      1.0
    else
    (1000.0 * number.to_f).truncate.to_f / 1000.0
    end
  end

  def self.truncating(hash)
    hash.map do |key, value|
      if value.nil?
        0.0
      end
      [key, round_decimal(value)]
    end.to_h
  end

  def self.nested_truncating(hash)
    hash.map do |key, value|
      if value.nil?
        0.0
      end
      new_value = truncating(value)
      [key, new_value]
    end.to_h
  end

  def self.variation(data_1, data_2)
    average(data_1).to_f / average(data_2).to_f
  end

  def self.average(hash)
    sum = hash.values.reduce(:+)
    count = hash.size
    sum.to_f / count.to_f
  end

  def self.compare_trends(trend_1,trend_2)
    common = trend_1.keys & trend_2.keys

    common_trend_1 ={}
    common.each {|year| common_trend_1[year]=trend_1[year]}
    common_trend_2 ={}
    common.each {|year| common_trend_2[year]=trend_2[year]}

    common_trend_1.merge(common_trend_2) do |year, av1, av2|
      round_decimal(av1.to_f/av2.to_f)
    end.sort.to_h
  end
end
