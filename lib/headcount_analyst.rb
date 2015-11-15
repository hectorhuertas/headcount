require './lib/stat'

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

    avg_1 / avg_2
    # general_variation(d1_name,
    #                   options[:against],
    #                   :enrollment,
    #                   :kindergarten_participation_by_year)
  end

  def general_variation(d1_name, d2_name, area, type)
    dist_1 = district_repository.find_by_name(d1_name)
    dist_2 = district_repository.find_by_name(d2_name)

    data_1 = load_district_data(dist_1, area, type)
    data_2 = load_district_data(dist_2, area, type)

    Stat.variation(data_1, data_2)
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

  def load_district_data(district, area, type)
    district.send(area).send(type)
  end

  info = {area: :enrollment, type: :kindergarten }
  def average(district, area, type)
    data = load_district_data(district, area, type)
    sum = data.values.reduce(:+)
    count = data.size
    sum / count
    # binding.pry
    # Stat.average(data)
  end

  def kindergarten_participation_against_high_school_graduation(d_name)
      dist = district_repository.find_by_name(d_name)
      state = district_repository.find_by_name('colorado')
      #
      #
      # kinder_average = average(dist, :enrollment, :kindergarten_participation_by_year)
      # kinder_state = average(state, :enrollment, :kindergarten_participation_by_year)
      # kinder_variation = kinder_average / kinder_state
      # kinder_variation = general_variation

      # graduation_average = average(dist, :enrollment,:kindergarten_participation_by_year)
      # graduation_state = average(state, :enrollment, :kindergarten_participation_by_year)
      # graduation_variation = graduation_average / graduation_state
      graduation_average = average(dist, :enrollment,:graduation_rate_by_year)
      graduation_state = average(state, :enrollment, :graduation_rate_by_year)
      graduation_variation = graduation_average / graduation_state

      kinder_variation / graduation_variation
      # kindergarten_participation_rate_variation_trend(d_name) / graduation_variation
  end

  def kindergarten_participation_correlates_with_high_school_graduation(options)
    if options[:for]
      if options[:for].upcase != 'COLORADO'
        correlation = kindergarten_participation_against_high_school_graduation(options[:for])
        if 0.6 < correlation && correlation < 1.5
          true
        end
      else
        passing = district_repository.districts.count{|d| kindergarten_participation_correlates_with_high_school_graduation(d) if d.name!='COLORADO'}
        if (passing / district_repository.districts.size) > 0.7
          true
        else
          false
        end
      end
    elsif options[:across]
      passing = options[:across].count{|d| kindergarten_participation_correlates_with_high_school_graduation(d)}
      if (passing / options[:across].size) > 0.7
        true
      else
        false
      end
    end
  end


end
