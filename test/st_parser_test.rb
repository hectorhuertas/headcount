require 'minitest/autorun'
require './lib/st_parser'

class StParserTest < Minitest::Test
  def test_it_exists
    assert StParser
  end

  def third_grade_test_data
    { 'COLORADO' => {
      third_grade: { 2008 => { math: 0.857, reading: 0.866, writing: 0.671 } } },
      'ACADEMY 20' => {
        third_grade: { 2008 => { math: 0.857, reading: 0.866, writing: 0.671 } } }
    }
  end

  def third_and_eighth_grade_test_data
    { 'COLORADO' => { 2008 => { :math => 0.697,
                                :reading => 0.703,
                                :writing => 0.501 },
                      2009 => { :math => 0.691,
                                :reading => 0.726,
                                :writing => 0.536 } },
      'ACADEMY 20' => { 2008 => { :math => 0.857,
                                  :reading => 0.864,
                                  :writing => 0.671 },
                        2009 => { :math => 0.824,
                                  :reading => 0.862,
                                  :writing => 0.706 } } }
  end

  def test_it_parses_third_and_eighth_grade_data
    expected = third_and_eighth_grade_test_data
    # e = StParser.third_and_eighth_grade('./test/data/3g.csv')
    # binding.pry
    assert_equal expected, StParser.third_and_eighth_grade('./test/data/3g.csv')
  end

  # def test_it_parses_8g_file
  #   expected = third_grade_test_data
  #   # e = StParser.third_grade('./test/data/3rd.csv')
  #   # binding.pry
  #   assert_equal expected, StParser.third_grade('./test/data/8g.csv')
  # end
end
