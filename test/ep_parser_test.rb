require 'minitest'
require './lib/ep_parser'

class EpParserTest < Minitest::Test
  def test_it_exists
    assert EpParser
  end

  def test_it_parses_full_economic_data_epr
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
    expected = { 'COLORADO' =>   { median_household_income:     { [2005, 2009] => 50_000.0, [2008, 2012] => 70_000.0 } },
                 'ACADEMY 20' =>   { median_household_income:     { [2006, 2010] => 80_000.0, [2008, 2012] => 90_000.0 } } }

    actual = EpParser.median_household_income('./test/data/mhi.csv')
    assert_equal expected, actual
  end

  def test_it_parses_median_income_data_na
    input = { economic_profile: {
      median_household_income: './test/data/mhi_weird.csv'
    } }
    expected = { 'COLORADO' =>   { median_household_income:     { [2005, 2009] => 50_000.0, [2008, 2012] => 70_000.0 } },
                 'ACADEMY' =>   { median_household_income:     { [2006, 2010] => 'N/A', [2008, 2012] => 90_000.0 } } }

    actual = EpParser.median_household_income('./test/data/mhi_weird.csv')
    assert_equal expected, actual
  end

  def test_it_parses_children_in_poverty
    input = { economic_profile: {
      children_in_poverty: './test/data/poverty.csv'
    } }
    expected = { 'ACADEMY 20' => {
      children_in_poverty: { 1995 => 0.032, 1997 => 0.035 } },
                 'ADAMS COUNTY 14' => {
                   children_in_poverty: { 1995 => 0.219, 1997 => 0.252 } } }
    actual = EpParser.children_in_poverty('./test/data/poverty.csv')
    assert_equal expected, actual
  end

  def test_it_parses_children_in_poverty_na
    input = { economic_profile: {
      children_in_poverty: './test/data/poverty_weird.csv'
    } }
    expected = { 'ACADEMY 20' => {
      children_in_poverty: { 1995 => 0.032, 1997 => 0.035 } },
                 'ADAMS COUNTY 14' => {
                   children_in_poverty: { 1995 => 'N/A', 1997 => 0.252 } } }
    actual = EpParser.children_in_poverty('./test/data/poverty_weird.csv')
    assert_equal expected, actual
  end

  def test_it_parses_mhi_and_poverty
    input = {
      median_household_income: './test/data/mhi.csv',
      children_in_poverty: './test/data/poverty.csv'
    }
    expected = [{ name: 'COLORADO',
                  median_household_income: { [2005, 2009] => 50_000.0, [2008, 2012] => 70_000.0 } },
                { name: 'ACADEMY 20',
                  median_household_income: { [2006, 2010] => 80_000.0, [2008, 2012] => 90_000.0 },
                  children_in_poverty: { 1995 => 0.032, 1997 => 0.035 } },
                { name: 'ADAMS COUNTY 14',
                  children_in_poverty: { 1995 => 0.219, 1997 => 0.252 } }]
    actual = EpParser.profiles(input)
    assert_equal expected, actual
  end

  def test_it_parses_lunch_help
    input = {
      free_or_reduced_price_lunch: './test/data/lunch_help.csv'
    }
    expected = { 'COLORADO' =>   {
      free_or_reduced_price_lunch:     {
        2000 => { percentage: 0.27, total: 195_149 },
        2001 => { total: 204_299, percentage: 0.27528 },
        2002 => { percentage: 0.28509, total: 214_349 } } },
                 'ACADEMY 20' =>   {
                   free_or_reduced_price_lunch:     {
                     2014 => { total: 3132, percentage: 0.12743 },
                     2012 => { percentage: 0.12539, total: 3006 },
                     2011 => { total: 2834, percentage: 0.1198 },
                     2010 => { percentage: 0.113 } } } }
    actual = EpParser.lunch_help('./test/data/lunch_help.csv')
    assert_equal expected, actual
  end

  def test_it_parses_title_i
    input = {
      title_i: './test/data/title_i.csv'
    }
    expected = { 'COLORADO' => {
      title_i: { 2009 => 0.216, 2011 => 0.224, 2012 => 0.22907, 2013 => 0.23178, 2014 => 0.23556 } },
                 'ACADEMY 20' => {
                   title_i: { 2009 => 0.014, 2011 => 0.011, 2012 => 0.01072, 2013 => 0.01246, 2014 => 0.0273 } } }
    actual = EpParser.title_i('./test/data/title_i.csv')
    assert_equal expected, actual
  end

  def test_it_parses_title_i_na
    input = {
      title_i: './test/data/title_i_weird.csv'
    }
    expected = { 'COLORADO' => {
      title_i: { 2009 => 0.216, 2011 => 0.224, 2012 => 'N/A', 2013 => 0.23178, 2014 => 0.23556 } },
                 'ACADEMY 20' => {
                   title_i: { 2009 => 'N/A', 2011 => 0.011, 2012 => 0.01072, 2013 => 0.01246, 2014 => 0.0273 } } }
    actual = EpParser.title_i('./test/data/title_i_weird.csv')
    assert_equal expected, actual
  end

  def test_it_parses_full_economic_data
    input = {
      median_household_income: './test/data/mhi.csv',
      children_in_poverty: './test/data/poverty.csv',
      free_or_reduced_price_lunch: './test/data/lunch_help.csv',
      title_i: './test/data/title_i.csv'
    }
    expected = [{ name: 'COLORADO',
                  median_household_income: { [2005, 2009] => 50_000.0, [2008, 2012] => 70_000.0 },
                  free_or_reduced_price_lunch:    { 2000 => { percentage: 0.27, total: 195_149 }, 2001 => { total: 204_299, percentage: 0.27528 }, 2002 => { percentage: 0.28509, total: 214_349 } },
                  title_i: { 2009 => 0.216, 2011 => 0.224, 2012 => 0.22907, 2013 => 0.23178, 2014 => 0.23556 } },
                { name: 'ACADEMY 20',
                  median_household_income: { [2006, 2010] => 80_000.0, [2008, 2012] => 90_000.0 },
                  children_in_poverty: { 1995 => 0.032, 1997 => 0.035 },
                  free_or_reduced_price_lunch: { 2014 => { total: 3132, percentage: 0.12743 },
                                                 2012 => { percentage: 0.12539, total: 3006 },
                                                 2011 => { total: 2834, percentage: 0.1198 },
                                                 2010 => { percentage: 0.113 } },
                  title_i: { 2009 => 0.014, 2011 => 0.011, 2012 => 0.01072, 2013 => 0.01246, 2014 => 0.0273 } },
                { name: 'ADAMS COUNTY 14', children_in_poverty: { 1995 => 0.219, 1997 => 0.252 } }]
    actual = EpParser.profiles(input)
    assert_equal expected, actual
  end
end
