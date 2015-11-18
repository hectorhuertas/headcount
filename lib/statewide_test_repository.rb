require_relative 'st_parser'
require_relative 'statewide_test'

class StatewideTestRepository
  attr_reader :statewide_test

  def initialize(statewide_test = [])
    @statewide_test = statewide_test
  end

  def load_data(data)
    if data[:statewide_testing]
      statewide_test_data = StParser.st_test(data[:statewide_testing])
      create_new_STtests(statewide_test_data)
    end
  end

  def find_by_name(name)
    statewide_test.find { |test| test.name == name.upcase }
  end

  def create_new_STtests(tests_data)
    tests_data.each do |test_data|
      @statewide_test << StatewideTest.new(test_data)
    end
  end
end
