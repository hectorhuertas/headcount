class District
  attr_reader :name, :enrollment

  def initialize(name)
    @name = name.values.first.upcase
    @enrollment = []
  end

  def add_enrollment(enrollment)
    @enrollment = enrollment
  end
end
