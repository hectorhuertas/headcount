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

  # def test_it_calculates_median_household_income_in_year
  #   assert_equal 50000, ep.median_household_income_in_year(2005)
  # end
end
