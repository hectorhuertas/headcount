require 'minitest'
require './lib/headcount_analyst'
require './lib/enrollment'

class HeadcountAnalystTest < Minitest::Test
  def test_it_exist
    assert HeadcountAnalyst
  end

  def test_it_takes_a_district_repository
    dr = DistrictRepository.new
    assert ha = HeadcountAnalyst.new(dr)
  end

  def test_it_compares_kindergarten_rates_between_two_districts

    e1 = Enrollment.new({name: "Dist_1",
                        kindergarten_participation: {2010 => 0.4}})
    e2 = Enrollment.new({name: "Dist_2",
                        kindergarten_participation: {2010 => 0.2}})
    er = EnrollmentRepository.new([e1,e2])

    dr = DistrictRepository.new
    dr.load_repos({enrollment: er})

    ha = HeadcountAnalyst.new(dr)
    d1_name = "Dist_1"
    d2_name = "Dist_2"

    rate = ha.kindergarten_participation_rate_variation(d1_name, :against => d2_name)
    assert_equal 2, rate
  end

  def test_it_calculates_kindergarten_participation_trends
    e1 = Enrollment.new({name: "Dist_1",
                        kindergarten_participation: {2010 => 1.0, 2012 => 2.0, 2014 => 2.0}})
    e2 = Enrollment.new({name: "Dist_2",
                        kindergarten_participation: {2010 => 2.0, 2011 => 3.0, 2014 => 1.0}})
    er = EnrollmentRepository.new([e1,e2])
    dr = DistrictRepository.new
    dr.load_repos({enrollment: er})
    ha = HeadcountAnalyst.new(dr)
    expected = {2010 => 0.5, 2014 => 2.0}

    assert_equal expected, ha.kindergarten_participation_rate_variation_trend('Dist_1', :against => 'Dist_2')
  end

  def test_it_loads_data_for_a_given_district_and_info
    dr = DistrictRepository.new
    ha = HeadcountAnalyst.new(dr)

    e1 = Enrollment.new({name: "Dist_1",
                        kindergarten_participation: {2010 => 1.0, 2012 => 2.0}})

    d = District.new(name:"Dist_1")
    d.add_enrollment(e1)
    expected = {2010 => 1.0, 2012 => 2.0}
    assert_equal expected, ha.load_district_data(d, :enrollment,:kindergarten_participation_by_year )
  end


  def test_it_returns_district_average
    dr = DistrictRepository.new
    ha = HeadcountAnalyst.new(dr)

    e1 = Enrollment.new({name: "Dist_1",
                        kindergarten_participation: {2010 => 1.0, 2012 => 2.0}})

    d = District.new(name:"Dist_1")
    d.add_enrollment(e1)

    assert_equal 1.5, ha.average(d, :enrollment, :kindergarten_participation_by_year)
  end

  def test_it_compares_kindergarten_and_high_school_enrollments
    e1 = Enrollment.new({name: "Dist_1",
                        kindergarten_participation: {2010 => 1.0, 2012 => 2.0},
                        high_school_graduation:     {2010 => 2.0, 2011 => 3.0, 2014 => 1.0}})
    e2 = Enrollment.new({name: "colorado",
                        kindergarten_participation: {2010 => 1.0, 2012 => 2.0},
                        high_school_graduation:     {2010 => 4.0, 2011 => 4.0, 2014 => 4.0}})
    er = EnrollmentRepository.new([e1,e2])
    dr = DistrictRepository.new
    dr.load_repos({enrollment: er})
    ha = HeadcountAnalyst.new(dr)
    assert_equal 2, ha.kindergarten_participation_against_high_school_graduation('Dist_1')
  end

  def test_it_checks_correlation
    e1 = Enrollment.new({name: "Dist_1",
                        kindergarten_participation: {2010 => 1.0, 2012 => 2.0},
                        high_school_graduation:            {2010 => 2.0, 2011 => 3.0, 2014 => 1.0}})
    e2 = Enrollment.new({name: "colorado",
                        kindergarten_participation: {2010 => 1.0, 2012 => 2.0},
                        high_school_graduation:            {2010 => 2.0, 2011 => 3.0, 2014 => 1.0}})
    er = EnrollmentRepository.new([e1,e2])
    dr = DistrictRepository.new
    dr.load_repos({enrollment: er})
    ha = HeadcountAnalyst.new(dr)
    assert ha.kindergarten_participation_correlates_with_high_school_graduation(for: 'Dist_1')
  end

  def test_it_detects_false_correlations
    e1 = Enrollment.new({name: "Dist_1",
                        kindergarten_participation: {2010 => 1.0, 2012 => 2.0},
                        high_school_graduation:            {2010 => 2.0, 2011 => 3.0, 2014 => 1.0}})
    e2 = Enrollment.new({name: "colorado",
                        kindergarten_participation: {2010 => 1.0, 2012 => 2.0},
                        high_school_graduation:            {2010 => 4.0, 2011 => 4.0, 2014 => 4.0}})
    er = EnrollmentRepository.new([e1,e2])
    dr = DistrictRepository.new
    dr.load_repos({enrollment: er})
    ha = HeadcountAnalyst.new(dr)
    refute ha.kindergarten_participation_correlates_with_high_school_graduation(for: 'Dist_1')
  end

  def test_it_detects_positive_correlation_statewise
    # skip
    #3 of 4 correlations positive
    e1 = Enrollment.new({name: "Dist_1",
                        kindergarten_participation: {2010 => 1.0, 2012 => 1.0},
                        high_school_graduation:     {2010 => 1.0, 2012 => 1.0}})
    e2 = Enrollment.new({name: "Dist_2",
                        kindergarten_participation: {2010 => 1.0, 2012 => 1.0},
                        high_school_graduation:     {2010 => 1.0, 2012 => 1.0}})
    e3 = Enrollment.new({name: "Dist_3",
                        kindergarten_participation: {2010 => 1.0, 2012 => 1.0},
                        high_school_graduation:     {2010 => 1.0, 2012 => 1.0}})
    e4 = Enrollment.new({name: "Dist_4",
                        kindergarten_participation: {2010 => 1.0, 2012 => 2.0},
                        high_school_graduation:     {2010 => 7.0, 2011 => 7.0, 2014 => 1.0}})
    e5 = Enrollment.new({name: "colorado",
                        kindergarten_participation: {2010 => 1.0, 2012 => 1.0},
                        high_school_graduation:     {2010 => 1.0, 2012 => 1.0}})
    er = EnrollmentRepository.new([e1,e2,e3,e4,e5])
    dr = DistrictRepository.new
    dr.load_repos({enrollment: er})
    ha = HeadcountAnalyst.new(dr)
    assert ha.kindergarten_participation_correlates_with_high_school_graduation(for: 'STATEWIDE')
  end

  def test_it_detects_false_correlation_statewise
    # skip
    #2 of 4 correlations positive
    e1 = Enrollment.new({name: "Dist_1",
                        kindergarten_participation: {2010 => 1.0, 2012 => 1.0},
                        high_school_graduation:     {2010 => 1.0, 2012 => 1.0}})
    e2 = Enrollment.new({name: "Dist_2",
                        kindergarten_participation: {2010 => 1.0, 2012 => 1.0},
                        high_school_graduation:     {2010 => 1.0, 2012 => 1.0}})
    e3 = Enrollment.new({name: "Dist_3",
                        kindergarten_participation: {2010 => 1.0, 2012 => 1.0},
                        high_school_graduation:     {2010 => 7.0, 2012 => 7.0}})
    e4 = Enrollment.new({name: "Dist_4",
                        kindergarten_participation: {2010 => 1.0, 2012 => 2.0},
                        high_school_graduation:     {2010 => 7.0, 2011 => 7.0, 2014 => 1.0}})
    e5 = Enrollment.new({name: "colorado",
                        kindergarten_participation: {2010 => 1.0, 2012 => 1.0},
                        high_school_graduation:     {2010 => 1.0, 2012 => 1.0}})
    er = EnrollmentRepository.new([e1,e2,e3,e4,e5])
    dr = DistrictRepository.new
    dr.load_repos({enrollment: er})
    ha = HeadcountAnalyst.new(dr)
    refute ha.kindergarten_participation_correlates_with_high_school_graduation(for: 'STATEWIDE')
  end

  def test_it_detects_correlation_when_variance_in_range
    dr = DistrictRepository.new
    ha = HeadcountAnalyst.new(dr)
    refute ha.correlates?(0.6)
    assert ha.correlates?(1)
    refute ha.correlates?(2)
  end
end
