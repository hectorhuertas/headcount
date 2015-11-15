require 'csv'
require 'pry'
require './lib/parser'
class EnrollmentRepo
  attr_reader :enrollments

  def initialize
    @enrollments = []
    @name = {}
  end

  def load_data(data)
    # binding.pry
    districts = Parser.enrollment(data[:enrollment])
    # loaded_data = []
    # data.each do |filename|
    #   loaded_data += Parser.parse(filename)
    # end
    # tst = loaded_data.dup
    # binding.pry
    # fun = loaded_data.group_by { |hash| hash[:name] }.map { |dist_name, dist_hashes| dist_hashes.reduce(:merge)}
    # binding.pry
    districts.each do |hash|
      # binding.pry
      @enrollments << Enrollment.new(hash)
    end
    # binding.pry
  end

  def find_by_name(name)
      @enrollments.find{|enrollment| enrollment.name == name.upcase}
  end

  def add_enrollments(enrollments)
    @enrollments += enrollments
  end

  # def connecting_info_in_hash(data)
  #   data
  #   name_now = data[:name]
  # end
end
