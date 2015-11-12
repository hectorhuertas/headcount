require 'minitest/autorun'
require_relative '../lib/enrollment_repo'

class EnrollmentRepoTest < Minitest::Test
  def test_it_exists
    assert EnrollmentRepo
  end

  def test_it_loads_several_data
    er = EnrollmentRepo.new
    er.load_data({
      :enrollment => {
        :kindergarten => "./test/data/kid.csv",
        :high_school_graduation => "./test/data/high_school.csv"
        }
      })
      
    assert_equal "COLORADO", er.find_by_name("Colorado").name
  end
  #
  # def test_it_loads_data
  #   er = EnrollmentRepo.new
  #   er.load_data({
  #     :enrollment => {
  #       :kindergarten => "./test/data/kid.csv"
  #     }
  #   })
  #   assert_equal "COLORADO", er.find_by_name("Colorado").name
  # end

end
