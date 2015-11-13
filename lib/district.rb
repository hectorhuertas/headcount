class District
  attr_reader :name
  attr_accessor :enrollment

  def initialize(name)
    @name = name.values.first.upcase
    @enrollment = []
  end

  def add_enrollment(data)
    enrollment = data.to_s.downcase
  end
end
