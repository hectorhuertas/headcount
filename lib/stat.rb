module Stat

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
      (av1/av2).round(3)
    end.sort.to_h
  end
end