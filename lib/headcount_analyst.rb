class HeadcountAnalyst
  attr_reader :district_repository

  def initialize(dr)
    @district_repository = dr
  end

  def kindergarten_participation_rate_variation(d1_name, options)
    d2_name = options[:against]
    dist_1 = district_repository.find_by_name(d1_name)
    dist_2 = district_repository.find_by_name(d2_name)

    avg_1 = district_average(dist_1,{area: :enrollment, type: :kindergarten_participation_by_year})
    avg_2 = district_average(dist_2,{area: :enrollment, type: :kindergarten_participation_by_year})
    avg_1/avg_2
  end

  #info = {area: :enrollment, type: :kindergarten }
  def district_average(district, info)
    data = load_district_data(district, info)
    sum = data.values.reduce(:+)
    count = data.size
    sum / count
  end

  def load_district_data(district, info)
    district.send(info[:area]).send(info[:type])
  end

  def kindergarten_participation_rate_variation_trend(d1_name, options)
    d2_name = options[:against]
    dist_1 = district_repository.find_by_name(d1_name)
    dist_2 = district_repository.find_by_name(d2_name)

    # rates_1 = dist_1.enrollment.kindergarten_participation_by_year
    # rates_2 = dist_2.enrollment.kindergarten_participation_by_year
    # binding.pry

    trend_1 = dist_1.enrollment.kindergarten_participation_by_year
    trend_2 = dist_2.enrollment.kindergarten_participation_by_year
    # kindergarten_trend_for_enrollments(dist_1.enrollment, dist_2.enrollment)
    compare_trends(trend_1, trend_2)
  end

  def compare_trends(trend_1,trend_2)
    common = trend_1.keys & trend_2.keys

    common_trend_1 ={}
    common.each {|year| common_trend_1[year]=trend_1[year]}
    common_trend_2 ={}
    common.each {|year| common_trend_2[year]=trend_2[year]}
     common_trend_1.merge(common_trend_2) do |year, av1, av2|
      av2/av1
    end.sort.to_h
  end

  # def kindergarten_participation_against_high_school_graduation(d_name)
  #   dist = district_repository.find_by_name(d1_name)
  #   kinder_variation = kindergarten_participation_average(dist.enrollment) / statewide_average(kindergarten)
  #   graduation_variation = district_graduation / statewide_average(graduation)
  #
  #   variance(kinder_variation,graduation)
  # end
  #
  # def variance(vaue1, value2)
  #   value2 / value1
  # end
end
