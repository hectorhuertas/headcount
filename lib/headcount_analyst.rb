require_relative 'stat'

class HeadcountAnalyst
  attr_reader :district_repository

  def initialize(dr)
    @district_repository = dr
  end

  def kindergarten_participation_rate_variation(d1_name, options = {against:'colorado'})
    d2_name = options[:against]
    dist_1 = district_repository.find_by_name(d1_name)
    dist_2 = district_repository.find_by_name(d2_name)

    data_1 = dist_1.enrollment.kindergarten_participation_by_year
    data_2 = dist_2.enrollment.kindergarten_participation_by_year

    avg_1 = Stat.average(data_1)
    avg_2 = Stat.average(data_2)

    (avg_1 / avg_2).round(3)
    # general_variation(d1_name,
    #                   options[:against],
    #                   :enrollment,
    #                   :kindergarten_participation_by_year)
  end

  def high_school_graduation_variation(d1_name, options = {against: 'colorado'})
      d2_name = options[:against]
      dist_1 = district_repository.find_by_name(d1_name)
      dist_2 = district_repository.find_by_name(d2_name)

      data_1 = dist_1.enrollment.graduation_rate_by_year
      data_2 = dist_2.enrollment.graduation_rate_by_year

      avg_1 = Stat.average(data_1)
      avg_2 = Stat.average(data_2)

      (avg_1 / avg_2).round(3)
  end

  def general_variation(d1_name, d2_name, area, type)
    dist_1 = district_repository.find_by_name(d1_name)
    dist_2 = district_repository.find_by_name(d2_name)

    data_1 = load_district_data(dist_1, area, type)
    data_2 = load_district_data(dist_2, area, type)

    Stat.variation(data_1, data_2).round(3)
  end

  # def general_variance(d_name, area1, type1, area2, type2)
  #   dist = district_repository.find_by_name(d_name)
  #
  #   v1 = general_variation / general_variation
  # end

  def kindergarten_participation_rate_variation_trend(d1_name, options)
    d2_name = options[:against]
    dist_1 = district_repository.find_by_name(d1_name)
    dist_2 = district_repository.find_by_name(d2_name)

    data_1 = dist_1.enrollment.kindergarten_participation_by_year
    data_2 = dist_2.enrollment.kindergarten_participation_by_year
    Stat.compare_trends(data_1, data_2)
  end

  def load_district_data(d_name, area, type)
    district = district_repository.find_by_name(d_name)
    district.send(area).send(type)
  end

  info = {area: :enrollment, type: :kindergarten }
  def average(district, area, type)
    data = load_district_data(district, area, type)
    sum = data.values.reduce(:+)
    count = data.size
    (sum / count).round(3)
  end

  def kindergarten_participation_against_high_school_graduation(d_name)
      # binding.pry
      kinder_variation = kindergarten_participation_rate_variation(d_name)
      graduation_variation = high_school_graduation_variation(d_name)

      (kinder_variation / graduation_variation).round(3)
      # binding.pry
  end

  def kindergarten_participation_correlates_with_high_school_graduation(options)
    if options[:for] == 'STATEWIDE'
      correlated = district_repository.districts.count do |dist|
        next false if dist.name == 'COLORADO'
        # binding.pry
        varience = kindergarten_participation_against_high_school_graduation(dist.name)
        correlates?(varience)
        # false if dist .name == 'COLORADO'
      end
      # binding.pry
      (correlated / (district_repository.districts.count.to_f - 1)) > 0.7
    elsif options[:against] != nil
      district_names = options[:against]
      #get districts form names
      correlated = district_names.count do |d_name|
        varience = kindergarten_participation_against_high_school_graduation(d_name)
        correlates?(varience)
      end
      (correlated / (district_names.count.to_f)) > 0.7
    elsif options[:for] != nil
      variance = kindergarten_participation_against_high_school_graduation(options[:for])
      correlates?(variance)
    end
  end

  def correlates?(variance)
    0.6 < variance && variance < 1.5
  end


end
