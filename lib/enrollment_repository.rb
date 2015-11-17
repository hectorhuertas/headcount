require 'pry'
require_relative 'parser'
require_relative 'enrollment'
class EnrollmentRepository
  attr_reader :enrollments

  def initialize(enrollments=[])
    @enrollments = enrollments
  end

  def load_data(data)
    enrollments_data = Parser.enrollment(data[:enrollment])
    enrollments_data.each do |hash|
      @enrollments << Enrollment.new(hash)
    end
  end

  def find_by_name(name)
      @enrollments.find{|enrollment| enrollment.name == name.upcase}
  end
end
