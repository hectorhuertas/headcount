require 'minitest'
require 'statewide_test_repository'

class StatewideTestRepositoryTest < Minitest::Test
  def test_it_exist
    assert StatewideTestRepository
  end

  def test_it_loads_3rd_grade
    skip
    str = StatewideTestRepository.new
    str.load_data(statewide_testing: {
                    third_grade: './data/3rd.csv'
                  })
    assert_equal 'dd', str.find_by_name('coloRADo')
  end

  def test_find_by_name_case_insensitive
    str = StatewideTestRepository.new([StatewideTest.new(name: 'fake')])
    assert_equal 'FAKE', str.find_by_name('fake').name
  end

  def test_find_by_another_name_case_insensitive
    str = StatewideTestRepository.new([StatewideTest.new(name: 'NOT')])
    assert_equal 'NOT', str.find_by_name('noT').name
  end

  def test_creates_new_STtest
    str = StatewideTestRepository.new
    tests_data = [{name: "yeah"}]
    str.create_new_STtests(tests_data)
    assert_equal "YEAH", str.find_by_name("yeah").name
  end

  def test_creates_another_new_STtest
    str = StatewideTestRepository.new
    tests_data = [{name: "bob"}]
    str.create_new_STtests(tests_data)
    assert_equal "BOB", str.find_by_name("bob").name
  end

  def test_creates_several_STtest
    str = StatewideTestRepository.new
    tests_data = [{name: "yeah"},{name: "bob"} ]
    str.create_new_STtests(tests_data)
    assert_equal "YEAH", str.find_by_name("yeah").name
    assert_equal "BOB", str.find_by_name("bob").name
  end

  def test_creates_different_several_STtest
    str = StatewideTestRepository.new
    tests_data = [{name: "one"},{name: "two"} ]
    str.create_new_STtests(tests_data)
    assert_equal "ONE", str.find_by_name("one").name
    assert_equal "TWO", str.find_by_name("two").name
  end

  def test_it_loads_data
    skip
    str = StatewideTestRepository.new
    str.load_data({
      :statewide_testing => {
      :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
      :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
      :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
      :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
      :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
  }
})
str = str.find_by_name("ACADEMY 20")
  end
end
