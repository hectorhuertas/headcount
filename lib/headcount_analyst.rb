require_relative 'stat'
require 'pry'
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
    return "N/A" if na_check(data_1, data_2)

    avg_1 = Stat.average(data_1)
    avg_2 = Stat.average(data_2)

    Stat.round_decimal(avg_1 / avg_2)
  end

  def na_check(data_1, data_2)
    data_1 == "N/A"|| data_2 == "N/A"
  end

  def high_school_graduation_variation(d1_name, options = {against: 'colorado'})
      d2_name = options[:against]
      dist_1 = district_repository.find_by_name(d1_name)
      dist_2 = district_repository.find_by_name(d2_name)

      data_1 = dist_1.enrollment.graduation_rate_by_year
      data_2 = dist_2.enrollment.graduation_rate_by_year
      return "N/A" if na_check(data_1, data_2)

      avg_1 = Stat.average(data_1)
      avg_2 = Stat.average(data_2)

      Stat.round_decimal(avg_1 / avg_2)
  end

  def kindergarten_participation_rate_variation_trend(d1_name, options)
    d2_name = options[:against]
    dist_1 = district_repository.find_by_name(d1_name)
    dist_2 = district_repository.find_by_name(d2_name)

    data_1 = dist_1.enrollment.kindergarten_participation_by_year
    data_2 = dist_2.enrollment.kindergarten_participation_by_year
    return "N/A" if na_check(data_1, data_2)

    Stat.compare_trends(data_1, data_2)
  end

  def load_district_data(d_name, area, type)
    district = district_repository.find_by_name(d_name.name)
    district.send(area).send(type)
  end

  def kindergarten_participation_against_high_school_graduation(d_name)
      kinder_variation = kindergarten_participation_rate_variation(d_name)
      graduation_variation = high_school_graduation_variation(d_name)
      return "N/A" if na_check(kinder_variation, graduation_variation)

      Stat.round_decimal(kinder_variation / graduation_variation)
  end

  def kindergarten_participation_correlates_with_high_school_graduation(options)
    if options[:for] == 'STATEWIDE'
      correlated = district_repository.districts.count do |dist|
        next false if dist.name == 'COLORADO'
        check_district_correlation(dist.name)
      end
      (correlated / (district_repository.districts.count.to_f - 1)) > 0.7
    elsif options[:across] != nil
      check_multiple_districts_correlation(options[:across])
    elsif options[:for] != nil
      check_district_correlation(options[:for])
    end
  end

  def check_multiple_districts_correlation(district_names)
    correlated = district_names.count do |d_name|
      check_district_correlation(d_name)
    end
    (correlated.to_f / (district_names.count)) > 0.7
  end

  def check_district_correlation(d_name)
    variance = kindergarten_participation_against_high_school_graduation(d_name)
    correlates?(variance)
  end

  def correlates?(variance)
    return false if variance == 'N/A'
    0.6 < variance && variance < 1.5
  end


  def validate_options(options)
    raise InsufficientInformationError unless options[:grade]
    raise UnknownDataError unless [3,8].include?(options[:grade])
  end

  def weighted_na_problem(math, reading, writing)
    stuff = [math, reading, writing].select {|value| value != "N/A" }
    amount = stuff.count
    return "N/A" if stuff.empty?
    stuff.reduce(:+) / amount
  end

  def subject_growth(dist, grade, subject)
    years = dist.statewide_test.proficient_by_grade(grade).keys
    return 'N/A' if years.all? { |year| dist.statewide_test.proficient_for_subject_by_grade_in_year(subject,grade, year) == "N/A"}

    most_recent_year =  most_recent_year(dist,grade,subject, years)
    oldest_year = oldest_year(dist,grade,subject, years)
    return 'N/A' if (most_recent_year - oldest_year) == 0
    max = dist.statewide_test.proficient_for_subject_by_grade_in_year(subject,grade, most_recent_year)
    min = dist.statewide_test.proficient_for_subject_by_grade_in_year(subject,grade, oldest_year)

    (max - min) / (most_recent_year - oldest_year)

  end

  def most_recent_year(dist,grade, subject, years)
    years.max_by do |year|
      value = dist.statewide_test.proficient_for_subject_by_grade_in_year(subject,grade, year)
      value == 'N/A' ? 0 : year
    end
  end

  def oldest_year(dist,grade, subject, years)
    years.min_by do |year|
      value = dist.statewide_test.proficient_for_subject_by_grade_in_year(subject,grade, year)
      value == 'N/A' ? 99999 : year
    end
  end

  def district_growth(dist, options)
    if options[:subject]
      subject_growth(dist,options[:grade], options[:subject])
    elsif options[:weighting]
      weighted_average(dist,options)
    else
      simple_average(dist,options)
    end
  end

  def simple_average(dist,options)
    math = subject_growth(dist,options[:grade], :math)
    reading = subject_growth(dist,options[:grade], :reading)
    writing = subject_growth(dist,options[:grade], :writing)
    return 'N/A' if [math,reading,writing].any?{|subject| subject == 'N/A'}
    (math + reading + writing) / 3
  end

  def weighted_average(dist,options)
    math = subject_growth(dist,options[:grade], :math)
    reading = subject_growth(dist,options[:grade], :reading)
    writing = subject_growth(dist,options[:grade], :writing)

    return 'N/A' if [math,reading,writing].any?{|subject| subject == 'N/A'}

    math_weight = options[:weighting][:math]
    reading_weight = options[:weighting][:reading]
    writing_weight = options[:weighting][:writing]

    math * math_weight + reading * reading_weight + writing * writing_weight
  end

  def format_growth(dist,options)
    [dist.name, Stat.round_decimal(district_growth(dist, options))]
  end

  def top_statewide_test_year_over_year_growth(options)
    validate_options(options)
    sorted_districts = district_repository.districts.sort_by do |district|
      growth = district_growth(district, options)
      growth == 'N/A' ? 0.0 : growth
    end.reverse

    if options[:top]
      tops = sorted_districts.take(options[:top])
      tops.map do |district|
        format_growth(district, options)
      end
    else
      format_growth(sorted_districts.first, options)
    end
  end

end
