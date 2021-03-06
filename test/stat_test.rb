require 'minitest'
require './lib/stat'

class StatTest < Minitest::Test

  def test_round_decimal_truncates_at_three_decimals
    assert_equal 3.494, Stat.round_decimal(3.4949999)
  end

  def test_truncating_takes_hash
    input = {2010 => 1.239393}
    result = {2010 => 1.239}
    assert_equal result, Stat.truncating(input)
  end

  def test_truncating_take_multiple_values
    input = {2010 => 1.2393, 2011 => 2.3939}
    result = {2010 => 1.239, 2011 => 2.393}
    assert_equal result, Stat.truncating(result) 
  end

  def test_it_exist
    assert Stat
  end

  def test_it_averages_data
    input = {2010 => 2, "2013" => 4}

    assert_equal 3, Stat.average(input)
  end

  def test_calculates_variation
    set_1 = {2010 => 1.0, 2012 => 2.0, 2014 => 3.0}
    set_2 = {2010 => 3.0, 2011 => 4.0, 2014 => 5.0}

    assert_equal 0.5, Stat.variation(set_1,set_2)
  end

  def test_it_compares_trends
    trend_1 = {2010 => 1.0, 2012 => 2.0, 2014 => 2.0}
    trend_2 = {2010 => 2.0, 2011 => 3.0, 2014 => 1.0}

    expected = {2010 => 0.5, 2014 => 2.0}

    assert_equal expected, Stat.compare_trends(trend_1, trend_2)
  end
end
