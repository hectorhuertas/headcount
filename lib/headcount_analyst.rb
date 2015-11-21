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
      # return "N/A" if data_1 == "N/A"|| data_2 == "N/A"
      return "N/A" if na_check(data_1, data_2)

      avg_1 = Stat.average(data_1)
      avg_2 = Stat.average(data_2)

      Stat.round_decimal(avg_1 / avg_2)
  end

  # def general_variation(d1_name, d2_name, area, type)
  #   dist_1 = district_repository.find_by_name(d1_name)
  #   dist_2 = district_repository.find_by_name(d2_name)
  #
  #   data_1 = load_district_data(dist_1, area, type)
  #   data_2 = load_district_data(dist_2, area, type)
  #
  #   Stat.round_decimal(Stat.variation(data_1, data_2))
  # end

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
    return "N/A" if na_check(data_1, data_2)

    # return "N/A" if data_1 == "N/A"|| data_2.values == "N/A"
    Stat.compare_trends(data_1, data_2)
  end

  def load_district_data(d_name, area, type)
    # binding.pry
    district = district_repository.find_by_name(d_name.name)
    district.send(area).send(type)
  end

  # info = {area: :enrollment, type: :kindergarten }
  # def average(district, area, type)
  #   data = load_district_data(district, area, type)
  #   sum = data.values.reduce(:+)
  #   count = data.size
  #   Stat.round_decimal(sum / count)
  # end

  def kindergarten_participation_against_high_school_graduation(d_name)
      kinder_variation = kindergarten_participation_rate_variation(d_name)
      graduation_variation = high_school_graduation_variation(d_name)
      # binding.pry
      # return "N/A" if data_1 == "N/A"|| data_2.values == "N/A"
      return "N/A" if na_check(kinder_variation, graduation_variation)

      Stat.round_decimal(kinder_variation / graduation_variation)
      # binding.pry
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

  def top_statewide_test_year_over_year_growth(options)
    validate_options(options)
    if options[:top]
      sorted = district_repository.districts.sort_by do |district|
        # statewide_test_year_over_year_growth(district, options)
        if statewide_test_year_over_year_growth(district, options) == 'N/A'
          0
        else
          statewide_test_year_over_year_growth(district, options)
        end
      end
      sorted.reverse.take(options[:top])
    else
    top = district_repository.districts.max_by do |district|
      if statewide_test_year_over_year_growth(district, options) == 'N/A'
        0
      else
        statewide_test_year_over_year_growth(district, options)
      end
    end
    [top.name, statewide_test_year_over_year_growth(top, options)]
    end
  end

  def statewide_test_year_over_year_growth(dist, options)
    years = dist.statewide_test.proficient_by_grade(options[:grade]).keys
     return 'N/A' if years.size < 2
     return 'N/A' if years.all? { |year| dist.statewide_test.proficient_for_subject_by_grade_in_year(options[:subject],options[:grade],year) == 'N/A'}
     if options[:subject]
       max = years.max_by do |year|
         if dist.statewide_test.proficient_for_subject_by_grade_in_year(options[:subject],options[:grade],year) == "N/A"
           0
         else
           year
         end
       end
       min = years.min_by do |year|
        # dist.statewide_test.proficient_for_subject_by_grade_in_year(options[:subject],options[:grade],year)
       # binding.pry
       if dist.statewide_test.proficient_for_subject_by_grade_in_year(options[:subject],options[:grade],year) == "N/A"
         99999
       else
         year
       end
      end
      #  binding.pry
       actual = dist.statewide_test.proficient_for_subject_by_grade_in_year(options[:subject], options[:grade], max)
       old = dist.statewide_test.proficient_for_subject_by_grade_in_year(options[:subject], options[:grade], min)
       # binding.pry
     else
       max = years.max_by do |year|
         # dist.statewide_test.proficient_for_subject_by_grade_in_year(options[:subject],options[:grade],year) || 0
         weighted_average(dist, options, year) || 0
       end
       min = years.min_by do |year|
         # dist.statewide_test.proficient_for_subject_by_grade_in_year(options[:subject],options[:grade],year) || 99
         weighted_average(dist, options, year) || 99
       end
       actual = weighted_average(dist,options, max)
       old = weighted_average(dist,options, min)
     end
    #  return 'N/A' if [max,min].all?{|value| value == 'N/A'}
     period = max - min
     # period = years[-1] - years[0]
     Stat.round_decimal((actual - old)/ period)
  end

  def weighted_average(dist,options,year)
    custom_error = "WeightError: Weigths must add to 1"
    raise custom_error if (options[:weighting] && (options[:weighting][:math] + options[:weighting][:reading] + options[:weighting][:writing]) != 1)

      math = dist.statewide_test.proficient_for_subject_by_grade_in_year(:math, options[:grade], year)
      reading = dist.statewide_test.proficient_for_subject_by_grade_in_year(:reading, options[:grade], year)
      writing = dist.statewide_test.proficient_for_subject_by_grade_in_year(:writing, options[:grade], year)

      math = (math == 'N/A' ? 0.0 : math)
      reading = (reading == 'N/A' ? 0.0 : reading)
      writing = (writing == 'N/A' ? 0.0 : writing)

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
    # information_error = "InsufficientInformationError:
    #                 A grade must be provided to answer this question"
    # grade_error = "UnknownDataError: #{options[:grade]} is not a known grade"
    raise InsufficientInformationError unless options[:grade]
    raise UnknownDataError unless [3,8].include?(options[:grade])
  end
end
