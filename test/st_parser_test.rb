require 'minitest/autorun'
require './lib/st_parser'

class StParserTest < Minitest::Test
  def test_it_exists
    assert StParser
  end

  def full_test_data
    [{ name: 'COLORADO',
       third_grade:        { 2008 => { math: 0.697, reading: 0.703, writing: 0.501 },
                             2009 => { math: 0.691, reading: 0.726, writing: 0.536 } },
       "All Students":        { 2011 => { math: 0.557, reading: 0.4, writing: 0.3 },
                                2012 => { math: 0.558, reading: 0.15, writing: 0.59 } },
       Asian:        { 2011 => { math: 0.709, reading: 0.6, writing: 0.2 },
                       2012 => { math: 0.719, reading: 0.1, writing: 0.66 } } },
     { name: 'ACADEMY 20',
       third_grade:        { 2008 => { math: 0.857, reading: 0.864, writing: 0.671 },
                             2009 => { math: 0.824, reading: 0.862, writing: 0.706 } },
       "All Students": { 2011 => { math: 0.68 } },
       Asian: { 2011 => { math: 0.816 } } },
     { name: 'CHICAGO', eighth_grade: { 2008 => { math: 0.697 } } },
     { name: 'MADRID',
       "Hawaiian/Pacific Islander": { 2014 => { reading: 0.519 } },
       Hispanic: { 2014 => { reading: 0.396 } } },
     { name: 'LONDON',
       "All Students": { 2011 => { writing: 77.0 } },
       Asian: { 2011 => { writing: 0.877 } } }]
  end

  def test_it_parses_full_st_tests_data
    input = {
      third_grade: './test/data/3g.csv',
      eighth_grade: './test/data/8g.csv',
      math: './test/data/math.csv',
      reading: './test/data/reading.csv',
      writing: './test/data/writing.csv' }
    expected = full_test_data
    actual = StParser.st_test(input)
    assert_equal expected, actual
  end

  def third_and_eighth_grade_test_data
    { 'COLORADO' => { 2008 => { math: 0.697,
                                reading: 0.703,
                                writing: 0.501 },
                      2009 => { math: 0.691,
                                reading: 0.726,
                                writing: 0.536 } },
      'ACADEMY 20' => { 2008 => { math: 0.857,
                                  reading: 0.864,
                                  writing: 0.671 },
                        2009 => { math: 0.824,
                                  reading: 0.862,
                                  writing: 0.706 } } }
  end

  def third_and_eighth_grade_test_data_weird
    { 'COLORADO' => { 2008 => { math: 0.697,
                                reading: 0.703,
                                writing: 0.501 },
                      2009 => { math: 0.691,
                                reading: 0.726,
                                writing: "N/A" } },
      'ACADEMY 20' => { 2008 => { math: 0.857,
                                  reading: 0.864,
                                  writing: 0.671 },
                        2009 => { math: 0.824,
                                  reading: 0.862,
                                  writing: "N/A" } } }
  end

  def race_data
    { 'COLORADO' => { "All Students":  { 2011 => { math: 0.557, reading: 0.557, writing: 0.557 },
                                         2012 =>  { math: 0.55, reading: 0.55, writing: 0.55 } },
                      Asian: { 2011 => { math: 0.709, reading: 0.709, writing: 0.709 },
                               2012 => { math: 0.719, reading: 0.719, writing: 0.719 } } },
      'ACADEMY 20' => { "All Students": { 2011 => { math: 0.68, reading: 0.68, writing: 0.68 },
                                          2012 => { math: 0.689, reading: 0.689, writing: 0.689 } },
                        Asian: { 2011 => { math: 0.816, reading: 0.816, writing: 0.816 },
                                 2012 => { math: 0.818, reading: 0.818, writing: 0.818 } } } }
  end

  def race_data_weird
    { 'COLORADO' => { "All Students":   { 2011 => { math: 0.557, reading: 0.557, writing: 0.557 },
                                          2012 =>  { math: 0.558, reading: 0.558, writing: 0.558 } },
                      Asian: { 2011 =>  { math: "N/A", reading: "N/A", writing: "N/A" },
                               2012 =>  { math: 0.719, reading: 0.719, writing: 0.719 } } },
      'ACADEMY 20' => { "All Students": { 2011 => { math: 0.68, reading: 0.68, writing: 0.68 },
                                          2012 => { math: 0.689, reading: 0.689, writing: 0.689 } },
                        Asian: { 2011 => { math: 0.816, reading: 0.816, writing: 0.816 },
                                 2012 => { math: "N/A", reading: "N/A", writing: "N/A" } } } }
  end

  def test_it_parses_third_and_eighth_grade_data
    expected = third_and_eighth_grade_test_data
    assert_equal expected, StParser.third_and_eighth_grade('./test/data/3g.csv')
  end

  def test_it_parses_avg_proficiencies
    input = { math: './test/data/race.csv',
              reading: './test/data/race.csv',
              writing: './test/data/race.csv'
    }
    actual = StParser.avg_proficiency(input)
    expected = race_data
    assert_equal expected, actual
  end

  def test_not_a_number_for_st_parser
    assert StParser.not_a_number?("L")
    assert StParser.not_a_number?("#")
    refute StParser.not_a_number?("3.392")
  end

  def test_it_parses_with_weird_data
    input = { math: './test/data/weird_race.csv',
              reading: './test/data/weird_race.csv',
              writing: './test/data/weird_race.csv'
    }
    actual = StParser.avg_proficiency(input)
    expected = race_data_weird
    assert_equal expected, actual
  end

    def test_it_parses_third_and_eighth_grade_data_weird
      expected = third_and_eighth_grade_test_data_weird
      assert_equal expected, StParser.third_and_eighth_grade('./test/data/weird_3g.csv')
    end
end
