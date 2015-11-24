require_relative 'stat'
class EconomicProfile
  attr_reader :data
  def initialize(data)
    @name = data[:name].upcase if data[:name]
    @data = data
  end

  def name
    @name
  end

  def estimated_median_household_income_in_year(year)
    fail UnknownDataError unless year.is_a?(Integer)
    relevant = find_relevant_data(year)
    relevant.reduce(:+) / relevant.size
  end

  def find_relevant_data(year)
    e = data[:median_household_income].keys.reduce([]) do |result, range|
    # binding.pry
      result += [data[:median_household_income][range]] if year.between?(range[0],range[1])
      result
    end.compact
    # binding.pry
    e
  end

  def median_household_income_average
    values = data[:median_household_income].values
    values.reduce(:+) / values.size
  end

  def children_in_poverty_in_year(year)
    fail UnknownDataError unless @data[:children_in_poverty][year]
    Stat.round_decimal(@data[:children_in_poverty][year])
  end

  def free_or_reduced_price_lunch_percentage_in_year(year)
    fail UnknownDataError unless @data[:free_or_reduced_price_lunch][year][:percentage]
    Stat.round_decimal(@data[:free_or_reduced_price_lunch][year][:percentage])

  end

  def free_or_reduced_price_lunch_number_in_year(year)
    fail UnknownDataError unless @data[:free_or_reduced_price_lunch][year][:total]
    Stat.round_decimal(@data[:free_or_reduced_price_lunch][year][:total])

  end

  def title_i_in_year(year)
    fail UnknownDataError unless @data[:title_i][year]
    Stat.round_decimal(@data[:title_i][year])
  end
end
