require 'minitest'
require './lib/headcount_analyst'
require './lib/enrollment'

class HeadcountAnalystTest < Minitest::Test
  #District -> need repos (enrollment, economic, testing)
  #repos -> need records
    # EnrollmentRepo needs Enrollment
    # Statewide testing needs StatewideTesting
    #Economic needs EconomicProfile
  def test_it_compares_kindergarten_rates_across_districts
    skip
    e1 = Enrollment.new({name: "Dist_1",
                        kindergarten_participation: {2010 => 1.0}})
    e2 = Enrollment.new({name: "Dist_2",
                        kindergarten_participation: {2010 => 1.0}})

    er = EnrollmentRepo.new
    er.add_enrollments([e1,e2])

    # skip
    dr = DistrictRepository.new

    dr.load_repos({enrollment: er})

    ha = HeadcountAnalyst.new(dr)
    dist_1 = "Dist_1"
    dist_2 = "Dist_2"
    rate = ha.kindergarten_participation_rate_variation(dist_2, :against => dist_1)
    assert_equal 1.0, rate
  end

  def test_it_compares_enrollment_rates_between_enrollments
    e1 = Enrollment.new({name: "Dist_1",
                        kindergarten_participation: {2010 => 1.0, 2011 => 2.0}})
    e2 = Enrollment.new({name: "Dist_2",
                        kindergarten_participation: {2010 => 2.0, 2011 => 3.0}})

    dr = DistrictRepository.new

    ha = HeadcountAnalyst.new(dr)
    average = ha.kindergarten_participation_rate_variation_of_enrollments(e1,e2)
    assert_equal 0.6, average
  end

  def test_it_averages_enrollments
    dr = DistrictRepository.new

    ha = HeadcountAnalyst.new(dr)
    e1 = Enrollment.new({name: "Dist_1",
                        kindergarten_participation: {2010 => 2.0, 2011 => 3.0}})
    average = ha.kindergarten_participation_average(e1)
    assert_equal 2.5, average
  end

  def test_it_calculates_trends
    e1 = Enrollment.new({name: "Dist_1",
                        kindergarten_participation: {2010 => 1.0, 2012 => 2.0, 2014 => 2.0}})
    e2 = Enrollment.new({name: "Dist_2",
                        kindergarten_participation: {2010 => 2.0, 2011 => 3.0, 2014 => 1.0}})

    dr = DistrictRepository.new

    ha = HeadcountAnalyst.new(dr)
    expected = {2010 => 2.0, 2014 => 0.5}
    # trend =ha.kindergarten_participation_rate_variation_trend("Dist_1", against: "Dist_2")
    assert_equal expected, ha.kindergarten_trend_for_enrollments(e1,e2)
  end
end
