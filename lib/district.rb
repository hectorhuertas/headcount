class District
  attr_reader :name, :enrollment, :tests

  def initialize(name)
    @name = name.values.first.upcase
    @enrollment = []
    @tests = []
  end

  def add_enrollment(enrollment)
    @enrollment = enrollment
  end

  def add_tests(tests)
    @tests = tests
  end
end
