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

  def race_data
    { 'COLORADO' =>  { 'All Students' => { "2011": { math: 0.557, reading: 0.557, writing: 0.557 },
                                          "2012": { math: 0.558, reading: 0.558, writing: 0.558 } },
                       'Asian' =>{ "2011": { math: 0.709, reading: 0.709, writing: 0.709 },
                                  "2012": { math: 0.719, reading: 0.719, writing: 0.719 } } },
      'ACADEMY 20' =>  { 'All Students' => { "2011": { math: 0.68, reading: 0.68, writing: 0.68 },
                                                "2012":      { math: 0.689, reading: 0.689, writing: 0.689 } },
                         'Asian' => { "2011": { math: 0.817, reading: 0.817, writing: 0.817 },
                                         "2012":{ math: 0.818, reading: 0.818, writing: 0.818 } } } }
  end

  def test_it_parses_third_and_eighth_grade_data
    # skip
    expected = third_and_eighth_grade_test_data
    # e = StParser.third_and_eighth_grade('./test/test/data/3g.csv')
    # binding.pry
    assert_equal expected, StParser.third_and_eighth_grade('./test/data/3g.csv')
  end

  def test_it_parses_avg_proficiencies
    skip
    input = { math: './test/data/race.csv',
              reading: './test/data/race.csv',
              writing: './test/data/race.csv'
    }
    expected = 'data'
    assert_equal expected, StParser.avg_proficiency(input)
  end

  def test_it_parses_full_st_tests_data
    skip
    input = { statewide_testing: {
      third_grade: './test/data/3g.csv',
      eighth_grade: './test/data/3g.csv',
      math: './test/data/race.csv',
      reading: './test/data/race.csv',
      writing: './test/data/race.csv' } }
    expected = 'array of statetests data'
    assert_equal expected, StParser.st_test(input[:statewide_testing])
  end
end
