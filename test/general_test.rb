require "minitest"
require "minitest/autorun"
require_relative "../../headcount/lib/district_repository"
require_relative "../../headcount/lib/district"
require_relative "../../headcount/lib/enrollment"
require_relative "../../headcount/lib/headcount_analyst"
require_relative "../../headcount/lib/statewide_test"
# require 'pry-rescue/minitest'
require_relative "../../headcount/lib/economic_profile_repository"
require_relative "../../headcount/lib/economic_profile"
class IterationTwoTest < Minitest::Test

  # def test_statewide_testing_relationships
  #   skip
  #     dr = district_repo
  #     district = dr.find_by_name("ACADEMY 20")
  #     statewide_test = district.statewide_test
  #     assert statewide_test.is_a?(StatewideTest)
  #
  #     ha = HeadcountAnalyst.new(dr)
  #     # binding.pry
  #     assert_equal "WILEY RE-13 JT", ha.top_statewide_test_year_over_year_growth(grade: 3, subject: :math).first
  #     assert_in_delta 0.3, ha.top_statewide_test_year_over_year_growth(grade: 3, subject: :math).last, 0.005
  #
  #     assert_equal "COTOPAXI RE-3", ha.top_statewide_test_year_over_year_growth(grade: 8, subject: :reading).first
  #     assert_in_delta 0.13, ha.top_statewide_test_year_over_year_growth(grade: 8, subject: :reading).last, 0.005
  #
  #     assert_equal "BETHUNE R-5", ha.top_statewide_test_year_over_year_growth(grade: 3, subject: :writing).first
  #     assert_in_delta 0.148, ha.top_statewide_test_year_over_year_growth(grade: 3, subject: :writing).last, 0.005
  #   end

#     def test_weighting_results_by_subject
#       skip
#   dr = district_repo
#   ha = HeadcountAnalyst.new(dr)
#
#   top_performer = ha.top_statewide_test_year_over_year_growth(grade: 8, :weighting => {:math => 0.5, :reading => 0.5, :writing => 0.0})
#   assert_equal "OURAY R-1", top_performer.first
#   # binding.pry
#   assert_in_delta 0.153, top_performer.last, 0.005
# end

  # def district_repo
  #   dr = DistrictRepository.new
  #   dr.load_data({:enrollment => {
  #                   :kindergarten => "./data/Kindergartners in full-day program.csv",
  #                   :high_school_graduation => "./data/High school graduation rates.csv",
  #                  },
  #                  :statewide_testing => {
  #                    :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
  #                    :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
  #                    :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
  #                    :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
  #                    :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
  #                  }
  #                })
  #   dr
  # end

  def statewide_repo
    str = StatewideTestRepository.new
    str.load_data({
                    :statewide_testing => {
                      :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
                      :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
                      :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
                      :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
                      :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
                    }
                  })
    str
  end

  def district_repo
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {
                    :kindergarten => "./data/Kindergartners in full-day program.csv",
                    :high_school_graduation => "./data/High school graduation rates.csv",
                   },
                   :statewide_testing => {
                     :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
                     :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
                     :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
                     :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
                     :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
                   }
                 })
    dr
  end

  def test_loading_econ_profile_data
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
   ["ACADEMY 20","WIDEFIELD 3","ROARING FORK RE-1","MOFFAT 2","ST VRAIN VALLEY RE 1J"].each do |dname|
     assert epr.find_by_name(dname).is_a?(EconomicProfile)
   end
 end
  end
