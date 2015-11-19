require 'minitest/autorun'
require_relative '../lib/enrollment'

class EnrollmentTest < Minitest::Test

  def test_enrollment_exists
    assert Enrollment

  end

  def test_name_gets_created_with_data
    enroll = Enrollment.new({name: 'Colorado', kindergarten_participation: {2010 => 0.05, 2011 => 0.1} })
    expected = {2010 => 0.05, 2011 => 0.1}
    assert_equal 'COLORADO', enroll.name
    assert_equal expected, enroll.kindergarten_participation_by_year
  end

  def test_that_participation_it_truncates_values
    enroll = Enrollment.new({name: 'Colorado', kindergarten_participation: {2010 => 0.05839, 2011 => 0.1} })
    result =  {2010 => 0.058, 2011 => 0.1}
    assert_equal result, enroll.kindergarten_participation_by_year
  end

  def test_participation_in_given_year
    enroll = Enrollment.new({name: 'Colorado', kindergarten_participation: {2010 => 0.05, 2011 => 0.1} })
    assert_equal 0.05, enroll.kindergarten_participation_in_year(2010)
  end

  def test_kindergarten_participation_in_given_year_truncated
    enroll = Enrollment.new({name: 'Colorado', kindergarten_participation: {2010 => 0.05893, 2011 => 0.13399} })
    assert_equal 0.058, enroll.kindergarten_participation_in_year(2010)
  end

  def test_high_school_gration_by_year
    enroll = Enrollment.new({name: 'Colorado', high_school_graduation: {2010 => 0.078, 2011 => 0.1} })
    expected = {2010 => 0.078, 2011 => 0.1}
    assert_equal 'COLORADO', enroll.name
    assert_equal expected, enroll.graduation_rate_by_year
  end

  def test_high_school_grad_by_year_truncates
    enroll = Enrollment.new({name: 'Colorado', high_school_graduation: {2010 => 0.05839, 2011 => 0.1384} })
    result =  {2010 => 0.058, 2011 => 0.138}
    assert_equal result, enroll.graduation_rate_by_year
  end

  def test_high_school_paricipation_in_given_year
    enroll = Enrollment.new({name: 'Colorado', high_school_graduation: {2010 => 0.38, 2011 => 0.1} })
    assert_equal 0.38, enroll.graduation_rate_in_year(2010)
  end

  def test_high_school_paricipation_in_given_year_is_truncated
    enroll = Enrollment.new({name: 'Colorado', high_school_graduation: {2010 => 0.3839, 2011 => 0.13273} })
    assert_equal 0.383, enroll.graduation_rate_in_year(2010)
  end
  #
  # def test_high_school_odd_characters_dont_return_by_year
  #    enroll = Enrollment.new({name: 'Colorado', high_school_graduation: {2010 => 0.393, 2011 => "N/A"}})
  #    expected = {2010 => 0.393}
  #    assert_equal expected, enroll.graduation_rate_by_year
  # end
  #
  # def test_kindergarten_odd_characters_dont_return_by_year
  #    enroll = Enrollment.new({name: 'Colorado', kindergarten_participation: {2010 => 0.393, 2011 => "N/A"}})
  #    expected = {2010 => 0.393}
  #    assert_equal expected, enroll.kindergarten_participation_by_year
  # end
  #
  # def test_high_school_odd_characters_dont_return_in_year
  #    enroll = Enrollment.new({name: 'Colorado', high_school_graduation: {2010 => 0.393, 2011 => "N/A"}})
  #    expected = {2010 => 0.393}
  #    assert_equal expected, enroll.graduation_rate_in_year(2011)
  # end
  #
  # def test_kindergarten_odd_characters_dont_return_in_year
  #    enroll = Enrollment.new({name: 'Colorado', kindergarten_participation: {2010 => 0.393, 2011 => "N/A"}})
  #    expected = {2010 => 0.393}
  #    assert_equal expected, enroll.kindergarten_participation_in_year(2011)
  # end
end
