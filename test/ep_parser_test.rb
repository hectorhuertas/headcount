require 'minitest'
require './lib/ep_parser'

class EpParserTest < Minitest::Test
  def test_it_exists
    assert EpParser
  end

  def test_it_parses_full_economic_data
    skip
    epr = EconomicProfileRepository.new
    epr.load_data(economic_profile: {
                    median_household_income: './data/Median household income.csv',
                    children_in_poverty: './data/School-aged children in poverty.csv',
                    free_or_reduced_price_lunch: './data/Students qualifying for free or reduced price lunch.csv',
                    title_i: './data/Title I students.csv'
                  })
    end

  def median_household_income_data
    { 'COLORADO' =>   { median_household_income:     { [2005, 2009] => 50_000.0, [2008, 2012] => 70_000.0 } },
      'ACADEMY' =>   { median_household_income:     { [2006, 2010] => 80_000.0, [2008, 2012] => 90_000.0 } } }
end

  def test_it_parses_median_income_data
    input = { economic_profile: {
      median_household_income: './test/data/mhi.csv'
    } }
    expected = median_household_income_data
    actual = EpParser.median_household_income('./test/data/mhi.csv')
    assert_equal expected, actual
  end
end
