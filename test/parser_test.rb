require 'minitest/autorun'
require './lib/parser'

class ParserTest < Minitest::Test
  def test_it_exists
    assert Parser
  end

  def kindergarten_test_data
    { 'COLORADO' => {
      kindergarten_participation: { 2007 => 0.394,
                                    2005 => 0.278 } },
      'AGATE 300' => {
        kindergarten_participation: { 2007 => 1.0,
                                      2006 => 0.5 } } }
  end

  def kindergarten_test_data_with_strange
    { 'COLORADO' => {
      kindergarten_participation: { 2007 => 0.394,
                                    2005 => 0.278,
                                    2006 => "N/A" } },
      'AGATE 300' => {
      kindergarten_participation: { 2007 => 1.0,
                                    2006 => 0.5,
                                    2005 => "N/A" } } }
  end

  def high_school_graduation_test_data
    { 'COLORADO' => {
      high_school_graduation: { 2010 => 0.724,
                                2011 => 0.739 } },
      'AGATE 300' => {
        high_school_graduation: { 2011 => 0.8,
                                  2012 => 0.6 } } }
  end

  def high_school_graduation_test_data_with_strange_values
    { 'COLORADO' => {
      high_school_graduation: { 2010 => 0.724,
                                2011 => 0.739,
                                2012 => "N/A"} },
      'AGATE 300' => {
        high_school_graduation: { 2011 => 0.8,
                                  2012 => 0.6,
                                  2013 => "N/A"} } }
  end


  def mixed_enrollment_test_data
    [{ name: 'COLORADO',
       kindergarten_participation: { 2007 => 0.394,
                                     2005 => 0.278 },
       high_school_graduation: { 2010 => 0.724,
                                 2011 => 0.739 } },
     { name: 'AGATE 300',
       kindergarten_participation: { 2007 => 1.0,
                                     2006 => 0.5 },
       high_school_graduation: { 2011 => 0.8,
                                 2012 => 0.6 } }]
  end

  def test_it_parses_kindergarten_data
    expected = kindergarten_test_data
    assert_equal expected, Parser.kindergarten('./test/data/kid.csv')
  end

  def test_it_parses_kindergarten_data_with_strange_values
    skip
    expected = kindergarten_test_data_with_strange
    assert_equal expected, Parser.kindergarten('./test/data/kid_weird.csv')
  end

  def test_it_parses_high_school_data
    expected = high_school_graduation_test_data
    assert_equal expected, Parser.high_school_graduation('./test/data/high_school.csv')
  end

  def test_it_parses_high_school_data_with_strange_values
    skip
    expected = high_school_graduation_test_data_with_strange_values
    assert_equal expected, Parser.high_school_graduation('./test/data/high_school_weird.csv')
  end

  def test_it_parses_single_type_enrollments
    input = { high_school_graduation: './test/data/high_school.csv' }
    expected = [{ name: 'COLORADO',
                  high_school_graduation: { 2010 => 0.724,
                                            2011 => 0.739 } },
                { name: 'AGATE 300',
                  high_school_graduation: { 2011 => 0.8,
                                            2012 => 0.6 } }]
    assert_equal expected, Parser.enrollment(input)
  end

  def test_it_parses_multiple_type_enrollments
    input = {  kindergarten: './test/data/kid.csv',
               high_school_graduation: './test/data/high_school.csv' }
    expected = mixed_enrollment_test_data
    assert_equal expected, Parser.enrollment(input)
  end

  def test_is_not_a_number?
    assert Parser.is_not_a_number?('N/A')
    refute Parser.is_not_a_number?('3.493')
  end

  def test_frame_work
    input = { location: 'Colorado', timeframe: '2010', data: '0.3023' }
    answer = { 'COLORADO' => { 2010 => 0.3023 } }
    assert_equal answer, Parser.frame_work(input)
  end

  def test_frame_work_returns_nil
    skip
    input = { location: 'Colorado', timeframe: '2010', data: 'LNE' }
    result = {"COLORADO"=>{2010=>"N/A"}}
    assert_equal result, Parser.frame_work(input)
  end
end
