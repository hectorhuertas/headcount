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
    skip
    str = StatewideTestRepository.new
    tests_data = [{ name: 'COLORADO',
            '3' => { 2008 => { math: 0.857, reading: 0.866, writing: 0.671 },
                     2009 => { math: 0.824, reading: 0.862, writing: 0.706 } } }]
    str.create_new_STtests(tests_data)
    assert_equal "COLORADO", str.find_by_name("colorado").name
  end
end
