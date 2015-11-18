require_relative 'parser'
require_relative 'enrollment'

class EnrollmentRepository
  attr_reader :enrollments

  def initialize(enrollments = [])
    @enrollments = enrollments
  end

  def load_data(data)
    if data[:enrollment]
      enrollments_data = Parser.enrollment(data[:enrollment])
      create_new_enrollments(enrollments_data)
    end
  end

  def find_by_name(name)
    enrollments.find { |enrollment| enrollment.name == name.upcase }
  end

  def create_new_enrollments(enrollments_data)
    enrollments_data.each do |hash|
      @enrollments << Enrollment.new(hash)
    end
  end
end
