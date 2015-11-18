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

  def test_creates_new_enrollments
    er =EnrollmentRepository.new
    test_data = [{name: 'tom'}]
    er.create_new_enrollments(test_data)
    assert_equal 'TOM', er.find_by_name('tom').name
  end

  def test_creates_another_enrollment
    er =EnrollmentRepository.new
    test_data = [{name: 'yay'}]
    er.create_new_enrollments(test_data)
    assert_equal 'YAY', er.find_by_name('yay').name
  end

  def test_creates_several_enrollment
    er =EnrollmentRepository.new
    test_data = [{name: 'tom'}, {name: 'hector'}]
    er.create_new_enrollments(test_data)
    assert_equal 'TOM', er.find_by_name('tom').name
    assert_equal 'HECTOR', er.find_by_name('hector').name
  end

  def test_find_by_name_case_insensitive
    er = EnrollmentRepository.new([Enrollment.new(name: 'fake')])
    assert_equal 'FAKE', er.find_by_name('fake').name
  end

  def test_find_by_another_name_case_insensitive
    er = EnrollmentRepository.new([Enrollment.new(name: 'NOT')])
    assert_equal 'NOT', er.find_by_name('noT').name
  end
end
