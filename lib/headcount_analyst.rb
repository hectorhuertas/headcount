require_relative 'stat'
require_relative 'errors'
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

    if data_1.empty? || data_2.empty?
      return "N/A"
    end
    avg_1 = Stat.average(data_1)
    avg_2 = Stat.average(data_2)

    Stat.round_decimal(avg_1 / avg_2)
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
      if data_1.empty? || data_2.empty?
        return "N/A"
      end

      avg_1 = Stat.average(data_1)
      avg_2 = Stat.average(data_2)

      Stat.round_decimal(avg_1 / avg_2)
  end

  def general_variation(d1_name, d2_name, area, type)
    dist_1 = district_repository.find_by_name(d1_name)
    dist_2 = district_repository.find_by_name(d2_name)

    data_1 = load_district_data(dist_1, area, type)
    data_2 = load_district_data(dist_2, area, type)

    Stat.round_decimal(Stat.variation(data_1, data_2))
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
    # binding.pry
    district = district_repository.find_by_name(d_name.name)
    district.send(area).send(type)
  end

  info = {area: :enrollment, type: :kindergarten }
  def average(district, area, type)
    data = load_district_data(district, area, type)
    sum = data.values.reduce(:+)
    count = data.size
    Stat.round_decimal(sum / count)
  end

  def kindergarten_participation_against_high_school_graduation(d_name)
      # binding.pry
      kinder_variation = kindergarten_participation_rate_variation(d_name)
      graduation_variation = high_school_graduation_variation(d_name)
      if kinder_variation.nil? || graduation_variation.nil?
        return "N/A"
      end

      Stat.round_decimal(kinder_variation / graduation_variation)
      # binding.pry
  end

  def kindergarten_participation_correlates_with_high_school_graduation(options)
    if options[:for] == 'STATEWIDE'
      correlated = district_repository.districts.count do |dist|
        next false if dist.name == 'COLORADO'
        # binding.pry
        varience = kindergarten_participation_against_high_school_graduation(dist.name)
        # next if variance.nil?
        correlates?(varience)
        # false if dist .name == 'COLORADO'
      end
      # binding.pry
      (correlated / (district_repository.districts.count.to_f - 1)) > 0.7
    elsif options[:across] != nil
      district_names = options[:across]
      #get districts form names
      correlated = district_names.count do |d_name|
        varience = kindergarten_participation_against_high_school_graduation(d_name)
        correlates?(varience) unless variance.nil?
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

  def top_statewide_test_year_over_year_growth(options)
    validate_options(options)
    if options[:top]
      sorted = district_repository.districts.sort_by do |district|
        statewide_test_year_over_year_growth(district, options)
      end
      sorted.reverse.take(options[:top])
    else
    top = district_repository.districts.max_by do |district|
      statewide_test_year_over_year_growth(district, options)
    end
    [top.name, statewide_test_year_over_year_growth(top, options)]
    end
  end

  def statewide_test_year_over_year_growth(dist, options)
    years = dist.statewide_test.proficient_by_grade(options[:grade]).keys
    return 0 if years.size < 2
    if options[:subject]
      actual = dist.statewide_test.proficient_for_subject_by_grade_in_year(options[:subject], options[:grade], years[-1])
      old = dist.statewide_test.proficient_for_subject_by_grade_in_year(options[:subject], options[:grade], years[0])
    else
      actual = weighted_average(dist,options, years[-1])
      old = weighted_average(dist,options, years[0])
      # binding.pry
    end
    period = years[-1] - years[0]
    (actual - old) / period
  end

  def weighted_average(dist,options,year)
    custom_error = "WeightError: Weigths must add to 1"
    raise custom_error if (options[:weighting] && (options[:weighting][:math] + options[:weighting][:reading] + options[:weighting][:writing]) != 1)

      math = dist.statewide_test.proficient_for_subject_by_grade_in_year(:math, options[:grade], year)
      reading = dist.statewide_test.proficient_for_subject_by_grade_in_year(:reading, options[:grade], year)
      writing = dist.statewide_test.proficient_for_subject_by_grade_in_year(:writing, options[:grade], year)

    if options[:weighting]
      math_weight = options[:weighting][:math]
      reading_weight = options[:weighting][:reading]
      writing_weight = options[:weighting][:writing]
      sum = math * math_weight + reading * reading_weight + writing * writing_weight
      # binding.pry
    else
      (math + reading + writing)/3.0
    end

  end

  def validate_options(options)
    # binding.pry
    information_error = "A grade must be provided to answer this question"
    grade_error = "UnknownDataError: #{options[:grade]} is not a known grade"
    raise InsufficientInformationError unless options[:grade]
    raise UnknownDataError unless [3,8].include?(options[:grade])
  end
end
