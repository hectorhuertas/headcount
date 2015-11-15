require 'minitest/autorun'
require_relative '../lib/enrollment_repository'

class EnrollmentRepositoryTest < Minitest::Test
  def fake_loaded_enrollment
    EnrollmentRepository.new([Enrollment.new({name:"FAKE"})])
  end


  def test_it_exists
    assert EnrollmentRepository
  end

  def test_find_by_name
    er = fake_loaded_enrollment
    assert_equal "FAKE", er.find_by_name("fake").name
  end

  def test_find_by_name_equals_nil_when_false
    er = fake_loaded_enrollment
    assert_equal nil, er.find_by_name("House")
  end

  def test_it_loads_several_data
    er = EnrollmentRepository.new
    er.load_data({
      :enrollment => {
        :kindergarten => "./test/data/kid.csv",
        :high_school_graduation => "./test/data/high_school.csv"
        }
      })

    assert_equal "COLORADO", er.find_by_name("Colorado").name
  end

  def test_it_loads_data
    er = EnrollmentRepository.new
    er.load_data({
      :enrollment => {
        :kindergarten => "./test/data/kid.csv"
      }
    })
    assert_equal "COLORADO", er.find_by_name("Colorado").name
  end


end
