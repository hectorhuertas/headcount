require_relative 'st_parser'
require_relative 'statewide_test'

class StatewideTestRepository
  attr_reader :tests

  def initialize(tests = [])
    @tests = tests
  end

  def load_data(data)
    if data[:statewide_testing]
      tests_data = StParser.st_test(data[:statewide_testing])
      create_new_STtests(tests_data)
    end
  end

  def find_by_name(name)
    tests.find { |test| test.name == name.upcase }
  end

  def create_new_STtests(tests_data)
    tests_data.each do |test_data|
      @tests << StatewideTest.new(test_data)
    end
  end
end
