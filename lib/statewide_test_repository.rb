# require 'st_parser'
# require_relative 'statewide_test'
class StatewideTestRepository
  attr_reader :tests
  def initialize(tests = [])
    @tests = tests
  end

  def find_by_name(name)
    tests.find{|test| test.name == name.upcase}
  end

  def load_data(data)
  end

  def retrieve_STtests_data
  end

  def create_new_STtests(tests_data)
    @tests << tests_data
  end
end
