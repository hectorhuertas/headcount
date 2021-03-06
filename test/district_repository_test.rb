require 'minitest/autorun'
require './lib/district_repository'

class DistrictRepositoryTest < Minitest::Test
  def test_it_exists
    assert DistrictRepository
  end

  def test_it_loads_kindergarten_data
    dr = DistrictRepository.new
    dr.load_data(enrollment: {
                   kindergarten: './test/data/kid.csv'
                 })
    assert dr.find_by_name('COLORADO')
    assert dr.find_by_name('COLORADO').enrollment
  end

  def test_it_loads_full_enrollment_data
    dr = DistrictRepository.new
    dr.load_data(enrollment: {
                   kindergarten: './test/data/kid.csv',
                   high_school_graduation: './test/data/high_school2.csv'
                 })
    assert dr.find_by_name('COLORADO')
    assert dr.find_by_name('COLORADO').enrollment
    assert dr.find_by_name('TURING')
    assert dr.find_by_name('TURING').enrollment
  end

  def test_it_loads_third_grade_data
    dr = DistrictRepository.new
    dr.load_data(statewide_testing: {
                   third_grade: './test/data/3g.csv'
                 })
    assert dr.find_by_name('COLORADO')
    assert dr.find_by_name('COLORADO').statewide_test
  end

  def test_it_loads_and_eighth_grade_data
    dr = DistrictRepository.new
    dr.load_data(statewide_testing: {
                   eighth_grade: './test/data/8g.csv'
                 })
    assert_equal 'CHICAGO', dr.find_by_name('CHICAGO').name
    assert dr.find_by_name('CHICAGO').statewide_test
  end

  def test_it_loads_proficiency
    dr = DistrictRepository.new
    dr.load_data(statewide_testing: {
                   math: './test/data/math.csv',
                   reading: './test/data/reading.csv',
                   writing: './test/data/writing.csv'
                 })
    assert dr.find_by_name('Madrid')
    assert dr.find_by_name('London')
    assert dr.find_by_name('Academy 20')
  end

  def test_it_loads_full_enrollment_and_testing_data
    dr = DistrictRepository.new
    dr.load_data(enrollment: {
                   kindergarten: './test/data/kid.csv',
                   high_school_graduation: './test/data/high_school2.csv'
                 },
                 statewide_testing: {
                   third_grade: './test/data/3g.csv',
                   eighth_grade: './test/data/8g.csv',
                   math: './test/data/math.csv',
                   reading: './test/data/reading.csv',
                   writing: './test/data/writing.csv'
                 })
    assert dr.find_by_name('COLORADO')
    assert dr.find_by_name('COLORADO').statewide_test
    assert dr.find_by_name('Madrid')
    assert dr.find_by_name('London')
    assert dr.find_by_name('turing')
    assert dr.find_by_name('Academy 20')
    assert_equal 'CHICAGO', dr.find_by_name('CHICAGO').name
    assert dr.find_by_name('CHICAGO').statewide_test
    # binding.pry
  end

  def test_find_by_name
    dr = DistrictRepository.new
    d = District.new(name: 'Colorado')
    dr.districts << d

    assert_equal d, dr.find_by_name('COLORADO')
  end

  def test_does_not_find_name
    dr = DistrictRepository.new

    assert_equal nil, dr.find_by_name('ALABAMA')
  end

  def test_creates_districts_from_a_name
    dr = DistrictRepository.new
    dr.create_districts(['COLoradO'])

    assert_equal 'COLORADO', dr.find_by_name('colorado').name
  end

  def test_it_find_names_case_insensitive
    dr = DistrictRepository.new
    dr.create_districts(%w(Colorado alabama WISCONSIN))

    assert_equal 'COLORADO', dr.find_by_name('Colorado').name
    assert_equal 'ALABAMA', dr.find_by_name('Alabama').name
    assert_equal 'WISCONSIN', dr.find_by_name('Wisconsin').name
  end

  def test_creates_districts_from_multiple_names
    dr = DistrictRepository.new
    dr.create_districts(%w(Colorado Alabama Wisconsin))

    assert_equal 'COLORADO', dr.find_by_name('Colorado').name
    assert_equal 'ALABAMA', dr.find_by_name('Alabama').name
    assert_equal 'WISCONSIN', dr.find_by_name('Wisconsin').name
  end

  def test_it_finds_all_matches_from_a_substring
    dr = DistrictRepository.new
    dr.create_districts(%w(Colorado Alabama Alticola))
    founded = dr.find_all_matching('col')
    assert_equal 2, founded.size
  end

  def test_it_loads_enrollment_repos
    e1 = Enrollment.new({name: "Dist_1",
                        kindergarten_participation: {2010 => 1.0, 2012 => 2.0}})

    er = EnrollmentRepository.new([e1])
    dr = DistrictRepository.new
    dr.load_repos({enrollment: er})
    ha = HeadcountAnalyst.new(dr)
    assert dr.enrollment_repo.find_by_name("Dist_1")
  end

  def test_it_loads_statewide_test_repos
    data = {name: "bob",
      third_grade: {
        2008 => { math: 0.6, reading: 0.7, writing: 0.8 },
        2009 => { math: 0.697, reading: 0.703, writing: 0.501 },
        2010 => { math: 0.697, reading: 0.703, writing: 0.501 },
        2011 => { math: 0.3, reading: 0.5, writing: 0.7 } }}
    str = StatewideTestRepository.new([StatewideTest.new(data)])
    dr = DistrictRepository.new
    dr.load_repos({statewide_test: str})
    assert dr.find_by_name("bob").statewide_test
  end

end
