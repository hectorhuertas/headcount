require 'economic_profile'
require 'minitest'
class EconomicProfileTest < Minitest::Test
  attr_reader :ep
  def setup
    data = { name: 'turing',
              median_household_income: { [2005, 2009] => 50_000, [2008, 2014] => 60_000 },
             children_in_poverty: { 2012 => 0.1845 },
             free_or_reduced_price_lunch: { 2014 => { percentage: 0.023, total: 100 } },
             title_i: { 2015 => 0.543 }
       }
    @ep = EconomicProfile.new(data)
end

  def test_it_exists
    assert EconomicProfile
  end

  def test_it_is_created_with_name
    assert_equal "TURING", ep.name
  end

  def test_it_calculates_median_household_income_in_year
    assert_equal 50000, ep.estimated_median_household_income_in_year(2005)
    assert_equal 55000, ep.estimated_median_household_income_in_year(2009)
    assert_equal 60000, ep.estimated_median_household_income_in_year(2010)
  end

  def test_it_calculates_median_household_income_average
    assert_equal 55000, ep.median_household_income_average
  end

  def test_it_calculates_poverty_in_year
    # binding.pry
    assert_equal 0.184, ep.children_in_poverty_in_year(2012)
  end

  def test_lunch_help_percentage
    assert_equal 0.023, ep.free_or_reduced_price_lunch_percentage_in_year(2014)
  end

  def test_lunch_help_total
    assert_equal 100, ep.free_or_reduced_price_lunch_number_in_year(2014)
  end

  def test_title_i
    assert_equal 0.543, ep.title_i_in_year(2015)
  end
end
