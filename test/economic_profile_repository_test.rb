require 'minitest'
require 'economic_profile_repository'

class EconomicProfileRepositoryTest < Minitest::Test
  def test_it_exist
    assert EconomicProfileRepository
  end

  def test_it_loads_data
    skip
    epr = EconomicProfileRepository.new
    epr.load_data({
  :economic_profile => {
    :median_household_income => "./data/Median household income.csv",
    :children_in_poverty => "./data/School-aged children in poverty.csv",
    :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
    :title_i => "./data/Title I students.csv"
  }
})
epr = epr.find_by_name("ACADEMY 20")
  end

  def test_it_loads_median_household_income
    skip
    epr = EconomicProfileRepository.new
    epr.load_data({:economic_profile => {:median_household_income => "./test/data/mhi.csv"}})
    assert_equal

    assert_equal "COLORADO", epr.find_by_name("colorado").name
  end
end
