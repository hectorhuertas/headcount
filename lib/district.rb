class District
  attr_reader :name, :enrollment, :statewide_test

  def initialize(name)
    @name = name.values.first.upcase
    @enrollment = []
    @statewide_test = []
  end

  def add_enrollment(enrollment)
    @enrollment = enrollment
  end

  def add_statewide_test(statewide_test)
    @statewide_test = statewide_test
  end
end
