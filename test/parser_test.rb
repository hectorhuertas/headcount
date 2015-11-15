require 'minitest/autorun'
require './lib/parser'

class ParserTest < Minitest::Test
  def test_it_exists
    assert Parser
  end

  def kindergarten_test_data
    { 'COLORADO' => {
      kindergarten_participation: { 2007 => 0.395,
                                    2005 => 0.278 } },
      'AGATE 300' => {
        kindergarten_participation: { 2007 => 1.0,
                                      2006 => 0.5 } } }
  end

  def high_school_graduation_test_data
    { 'COLORADO' => {
      high_school_graduation: { 2010 => 0.724,
                                2011 => 0.739 } },
      'AGATE 300' => {
        high_school_graduation: { 2011 => 0.8,
                                  2012 => 0.6 } } }
  end

  def mixed_enrollment_test_data
    [{ name: 'COLORADO',
       enrollment: { kindergarten_participation: { 2007 => 0.395,
                                                   2005 => 0.278 },
                     high_school_graduation: { 2010 => 0.724,
                                               2011 => 0.739 } } },
     { name: 'AGATE 300',
       enrollment: { kindergarten_participation: { 2007 => 1.0,
                                                   2006 => 0.5 },
                     high_school_graduation: { 2011 => 0.8,
                                               2012 => 0.6 } } }]
  end

  def test_it_parses_kindergarten_data
    expected = kindergarten_test_data
    assert_equal expected, Parser.kindergarten('./test/data/kid.csv')
  end

  def test_it_parses_high_school_data
    expected = high_school_graduation_test_data
    assert_equal expected, Parser.high_school_graduation('./test/data/high_school.csv')
  end

  def test_it_parses_single_type_enrollments
    input = { high_school_graduation: './test/data/high_school.csv' }
    expected = [{ name: 'COLORADO',
                  enrollment: high_school_graduation_test_data['COLORADO'] },
                { name: 'AGATE 300',
                  enrollment: high_school_graduation_test_data['AGATE 300'] }]
    assert_equal expected, Parser.enrollment(input)
  end

  def test_it_parses_multiple_type_enrollments
    input = {  kindergarten: './test/data/kid.csv',
               high_school_graduation: './test/data/high_school.csv' }
    expected = mixed_enrollment_test_data
    assert_equal expected, Parser.enrollment(input)
  end

  #   def test_it_parses_another_single_type_enrollments
  #     skip
  #   end
  #
  #   def test_it_parses_single_area_data
  #     skip
  #   end
  #
  #   def test_it_parses_complex_area_data
  #     skip
  # end
  #
  #   def test_it_merges_info_of_a_hash
  #     skip
  #   end

  # def test_it_calls_correct_parser
  # end
end
