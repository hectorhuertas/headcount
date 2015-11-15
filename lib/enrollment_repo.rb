require 'csv'
require 'pry'
require './lib/parser'
class EnrollmentRepo
  attr_reader :enrollments

  def initialize(enrollments=[])
    @enrollments = enrollments
    # @name = {}
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

  # def add_enrollments(enrollments)
  #   @enrollments += enrollments
  # end

  # def connecting_info_in_hash(data)
  #   data
  #   name_now = data[:name]
  # end
end
