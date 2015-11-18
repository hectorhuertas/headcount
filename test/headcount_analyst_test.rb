require 'minitest/autorun'
require './lib/headcount_analyst'
require './lib/enrollment'
require './lib/statewide_test'
require 'pry-rescue'

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
    e1 = Enrollment.new({name: "Dist_1",
                        kindergarten_participation: {2010 => 1.0, 2012 => 2.0}})

    er = EnrollmentRepository.new([e1])
    dr = DistrictRepository.new
    dr.load_repos({enrollment: er})
    ha = HeadcountAnalyst.new(dr)
    d = District.new(name:"Dist_1")
    expected = {2010 => 1.0, 2012 => 2.0}
    assert_equal expected, ha.load_district_data(d, :enrollment,:kindergarten_participation_by_year )
  end


  def test_it_returns_district_average

    e1 = Enrollment.new({name: "Dist_1",
                        kindergarten_participation: {2010 => 1.0, 2012 => 2.0}})
    er = EnrollmentRepository.new([e1])
    dr = DistrictRepository.new
    dr.load_repos({enrollment: er})
    ha = HeadcountAnalyst.new(dr)
    d = District.new(name:"Dist_1")
    # d.add_enrollment(e1)

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

  def test_it_detects_positive_correlation_statewise
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
    assert ha.kindergarten_participation_correlates_with_high_school_graduation(against: %w(Dist_1 Dist_2 Dist_3 Dist_4))
  end

  def test_it_detects_false_correlation_statewise
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
    refute ha.kindergarten_participation_correlates_with_high_school_graduation(against: %w(Dist_1 Dist_2 Dist_3 Dist_4))
  end

  def test_growth_raises_information_error_if_no_grade
    dr = DistrictRepository.new
    ha = HeadcountAnalyst.new(dr)
    assert_raises "InsufficientInformationError: A grade must be provided to answer this question" do
    ha.top_statewide_test_year_over_year_growth(subject: :math)
    end
  end

  def test_growth_raises_information_error_if_wrong_grade
    dr = DistrictRepository.new
    ha = HeadcountAnalyst.new(dr)
    assert_raises "InsufficientInformationError: A grade must be provided to answer this question" do
    ha.top_statewide_test_year_over_year_growth(subject: :math, grade: 9)
    end
  end

  def test_growth
    data = {name: "bob",
      third_grade: {
        2008 => { math: 3, reading: 0.7, writing: 0.8 },
        2009 => { math: 0.697, reading: 0.703, writing: 0.501 },
        2010 => { math: 0.697, reading: 0.703, writing: 0.501 },
        2011 => { math: 6, reading: 0.5, writing: 0.7 } }}
    str = StatewideTestRepository.new([StatewideTest.new(data)])
    dr = DistrictRepository.new
    dr.load_repos({statewide_test: str})
    ha = HeadcountAnalyst.new(dr)
    assert_equal 1, ha.statewide_test_year_over_year_growth(dr.find_by_name("bob"),grade: 3, subject: :math)
  end

  def test_top_growth
    data = {name: "bob",
      third_grade: {
        2008 => { math: 3, reading: 0.7, writing: 0.8 },
        2009 => { math: 0.697, reading: 0.703, writing: 0.501 },
        2010 => { math: 0.697, reading: 0.703, writing: 0.501 },
        2011 => { math: 6, reading: 0.5, writing: 0.7 } }}
    data2 = {name: "low",
      third_grade: {
        2008 => { math: 5, reading: 0.7, writing: 0.8 },
        2009 => { math: 0.697, reading: 0.703, writing: 0.501 },
        2010 => { math: 0.697, reading: 0.703, writing: 0.501 },
        2011 => { math: 6, reading: 0.5, writing: 0.7 } }}
    data3 = {name: "top",
      third_grade: {
        2008 => { math: 3, reading: 0.7, writing: 0.8 },
        2009 => { math: 0.697, reading: 0.703, writing: 0.501 },
        2010 => { math: 0.697, reading: 0.703, writing: 0.501 },
        2011 => { math: 9, reading: 0.5, writing: 0.7 } }}
    st1 = StatewideTest.new(data)
    st2 = StatewideTest.new(data2)
    st3 = StatewideTest.new(data3)
    str = StatewideTestRepository.new([st1,st2,st3])
    dr = DistrictRepository.new
    dr.load_repos({statewide_test: str})
    ha = HeadcountAnalyst.new(dr)
    assert_equal ["TOP", 2], ha.top_statewide_test_year_over_year_growth(grade: 3, subject: :math)
  end

  def test_top_growth_with_different_order
    data = {name: "bob",
      third_grade: {
        2008 => { math: 3, reading: 0.7, writing: 0.8 },
        2009 => { math: 0.697, reading: 0.703, writing: 0.501 },
        2010 => { math: 0.697, reading: 0.703, writing: 0.501 },
        2011 => { math: 6, reading: 0.5, writing: 0.7 } }}
    data2 = {name: "low",
      third_grade: {
        2008 => { math: 5, reading: 0.7, writing: 0.8 },
        2009 => { math: 0.697, reading: 0.703, writing: 0.501 },
        2010 => { math: 0.697, reading: 0.703, writing: 0.501 },
        2011 => { math: 6, reading: 0.5, writing: 0.7 } }}
    data3 = {name: "top",
      third_grade: {
        2008 => { math: 3, reading: 0.7, writing: 0.8 },
        2009 => { math: 0.697, reading: 0.703, writing: 0.501 },
        2010 => { math: 0.697, reading: 0.703, writing: 0.501 },
        2011 => { math: 9, reading: 0.5, writing: 0.7 } }}
    st1 = StatewideTest.new(data)
    st2 = StatewideTest.new(data2)
    st3 = StatewideTest.new(data3)
    str = StatewideTestRepository.new([st2,st3,st1])
    dr = DistrictRepository.new
    dr.load_repos({statewide_test: str})
    ha = HeadcountAnalyst.new(dr)
    assert_equal ["TOP", 2], ha.top_statewide_test_year_over_year_growth(grade: 3, subject: :math)
  end

  def test_top_3_growth_with_different_order
    data = {name: "bob",
      third_grade: {
        2008 => { math: 3, reading: 0.7, writing: 0.8 },
        2009 => { math: 0.697, reading: 0.703, writing: 0.501 },
        2010 => { math: 0.697, reading: 0.703, writing: 0.501 },
        2011 => { math: 6, reading: 0.5, writing: 0.7 } }}
    data2 = {name: "low",
      third_grade: {
        2008 => { math: 5, reading: 0.7, writing: 0.8 },
        2009 => { math: 0.697, reading: 0.703, writing: 0.501 },
        2010 => { math: 0.697, reading: 0.703, writing: 0.501 },
        2011 => { math: 6, reading: 0.5, writing: 0.7 } }}
    data3 = {name: "top",
      third_grade: {
        2008 => { math: 3, reading: 0.7, writing: 0.8 },
        2009 => { math: 0.697, reading: 0.703, writing: 0.501 },
        2010 => { math: 0.697, reading: 0.703, writing: 0.501 },
        2011 => { math: 9, reading: 0.5, writing: 0.7 } }}
    data4 = {name: "cero",
      third_grade: {
        2008 => { math: 6, reading: 0.7, writing: 0.8 },
        2009 => { math: 0.697, reading: 0.703, writing: 0.501 },
        2010 => { math: 0.697, reading: 0.703, writing: 0.501 },
        2011 => { math: 6, reading: 0.5, writing: 0.7 } }}
    st1 = StatewideTest.new(data)
    st2 = StatewideTest.new(data2)
    st3 = StatewideTest.new(data3)
    st4 = StatewideTest.new(data4)
    str = StatewideTestRepository.new([st1, st2, st3, st4])
    dr = DistrictRepository.new
    dr.load_repos({statewide_test: str})
    ha = HeadcountAnalyst.new(dr)
    top_3 = ha.top_statewide_test_year_over_year_growth(grade: 3, top: 3, subject: :math)
    # binding.pry
    assert top_3.include?(st1)
  end

end
