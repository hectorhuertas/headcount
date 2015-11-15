require 'minitest/autorun'
require './lib/parser'

class ParserTest < Minitest::Test
  def test_it_exists
    assert Parser
  end

  # def test_it_calls_correct_parser
  # end

  def kindergarten_test_data
    [{ name: 'COLORADO',
       kindergarten_participation: { 2007 => 0.395,
                                     2006 => 0.337,
                                     2005 => 0.278 } },
     { name: 'AGATE 300',
       kindergarten_participation: { 2007 => 1.0,
                                     2006 => 0.0,
                                     2005 => 1.0,
                                     2004 => 1.0 } },
     { name: 'ALAMOSA RE-11J',
       kindergarten_participation: { 2004 => 0.0,
                                     2008 => 0.994 } },
     { name: 'ARICKAREE R-2',
       kindergarten_participation: { 2007 => 0.0,
                                     2006 => 0.125,
                                     2005 => 0.0 } }]
end

  def high_school_graduation_test_data
    [{ name: 'COLORADO',
       high_school_graduation: { 2010 => 0.724,
                                 2011 => 0.739,
                                 2012 => 0.754,
                                 2013 => 0.769,
                                 2014 => 0.773 } },
     { name: 'AGATE 300',
       high_school_graduation: { 2010 => 1.0,
                                 2011 => 0.8,
                                 2012 => 0.0,
                                 2013 => 0.0 } },
     { name: 'ARICKAREE R-2',
       high_school_graduation: { 2010 => 1.0,
                                 2011 => 1.0,
                                 2012 => 1.0 } },
     { name: 'EAST YUMA COUNTY RJ-2',
       high_school_graduation: { 2010 => 0.0,
                                 2011 => 0.0,
                                 2012 => 0.0 } }]
   end

  def mixed_enrollment_test_data
    [{ name: 'COLORADO',
       kindergarten_participation: { 2007 => 0.395,
                                     2006 => 0.337,
                                     2005 => 0.278 },
       high_school_graduation: { 2010 => 0.724,
                                 2011 => 0.739,
                                 2012 => 0.754,
                                 2013 => 0.769,
                                 2014 => 0.773 } },
     { name: 'AGATE 300',
       kindergarten_participation: { 2007 => 1.0,
                                     2006 => 0.0,
                                     2005 => 1.0,
                                     2004 => 1.0 },
       high_school_graduation: { 2010 => 1.0,
                                 2011 => 0.8,
                                 2012 => 0.0,
                                 2013 => 0.0 } },
     { name: 'ALAMOSA RE-11J',
       kindergarten_participation: { 2004 => 0.0,
                                     2008 => 0.994 } },
     { name: 'ARICKAREE R-2',
       kindergarten_participation: { 2007 => 0.0,
                                     2006 => 0.125,
                                     2005 => 0.0 },
       high_school_graduation: { 2010 => 1.0,
                                 2011 => 1.0,
                                 2012 => 1.0 } }]
  end

  def test_it_parses_kindergarten_data
    expected = [{ name: 'COLORADO',
                  kindergarten_participation: { 2007 => 0.395,
                                                2006 => 0.337,
                                                2005 => 0.278 } },
                { name: 'AGATE 300',
                  kindergarten_participation: { 2007 => 1.0,
                                                2006 => 0.0,
                                                2005 => 1.0,
                                                2004 => 1.0 } },
                { name: 'ALAMOSA RE-11J',
                  kindergarten_participation: { 2004 => 0.0,
                                                2008 => 0.994 } },
                { name: 'ARICKAREE R-2',
                  kindergarten_participation: { 2007 => 0.0,
                                                2006 => 0.125,
                                                2005 => 0.0 } }]

    assert_equal expected, Parser.kindergarten('./test/data/kid.csv')
  end

  def test_it_parses_high_school_data
    expected = [{ name: 'COLORADO',
                  high_school_graduation: { 2010 => 0.724,
                                            2011 => 0.739,
                                            2012 => 0.754,
                                            2013 => 0.769,
                                            2014 => 0.773 } },
                { name: 'AGATE 300',
                  high_school_graduation: { 2010 => 1.0,
                                            2011 => 0.8,
                                            2012 => 0.0,
                                            2013 => 0.0 } },
                { name: 'ARICKAREE R-2',
                  high_school_graduation: { 2010 => 1.0,
                                            2011 => 1.0,
                                            2012 => 1.0 } },
                { name: 'EAST YUMA COUNTY RJ-2',
                  high_school_graduation: { 2010 => 0.0,
                                            2011 => 0.0,
                                            2012 => 0.0 } }]
    assert_equal expected, Parser.high_school_graduation('./test/data/high_school.csv')
  end

  def test_it_parses_single_type_enrollments
    skip
    input = {  high_school_graduation: './test/data/high_school.csv' }
    expected = { name: 'Colorado',
                 high_school_graduation:   { 2010 => 0.0,
                                             2011 => 0.0,
                                             2012 => 0.0,
                                             2013 => 0.0,
                                             2014 => 0.773 } }

    expected = high_school_graduation_test_data
    assert_equal expected, Parser.enrollment(input)
  end

  def test_it_parses_complex_enrollments
    skip
    input = {  kindergarten: './test/data/kid.csv',
               high_school_graduation: './test/data/high_school.csv' }
    expected = { name: 'Colorado',
                 kindergarten_participation:   { 2007 => 0.0,
                                                 2006 => 0.125,
                                                 2005 => 0.0,
                                                 2004 => 0.0,
                                                 2008 => 0.994 },
                 high_school_graduation:   { 2010 => 0.0,
                                             2011 => 0.0,
                                             2012 => 0.0,
                                             2013 => 0.0,
                                             2014 => 0.773 } }
    assert_equal expected, Parser.enrollment(input)
  end

  def test_it_parses_another_single_type_enrollments
    skip
    input = {  kindergarten: './test/data/kid.csv' }
    expected = { name: 'Colorado',
                 kindergarten_participation: { 2007 => 0.0,
                                               2006 => 0.125,
                                               2005 => 0.0,
                                               2004 => 0.0,
                                               2008 => 0.994 } }
    assert_equal expected, Parser.enrollment(input)
  end

  def test_it_parses_single_area_data
    skip
    input = { enrollment:
              { kindergarten: './test/data/kid.csv' } }
    expected = { name: 'Colorado',
                 kindergarten_participation: { 2007 => 0.0,
                                               2006 => 0.125,
                                               2005 => 0.0,
                                               2004 => 0.0,
                                               2008 => 0.994 } }
    assert_equal expected, Parser.parse(input)
  end

  def test_it_parses_complex_area_data
    skip
    input = { enrollment:
              { kindergarten: './test/data/kid.csv',
                high_school_graduation: './test/data/high_school.csv' } }
    expected = { name: 'Colorado',
                 kindergarten_participation: { 2007 => 0.0,
                                               2006 => 0.125,
                                               2005 => 0.0,
                                               2004 => 0.0,
                                               2008 => 0.994 } }
  end

  def test_it_merges_info_of_a_hash
    skip
  end
end
