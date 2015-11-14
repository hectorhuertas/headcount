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
    loaded_data = []
    data[:enrollment].each do |filename|
      loaded_data += Parser.parse(filename)
    end
    fun = loaded_data.group_by { |hash| hash[:name] }.map { |dist_name, dist_hashes| dist_hashes.reduce(:merge)}
    # binding.pry
    fun.each do |name|
      @enrollments << Enrollment.new(name)
    end
  end

  def find_by_name(name)
      @enrollments.find{|enrollment| enrollment.name == name.upcase}
  end

  def add_enrollments(enrollments)
    @enrollments += enrollments
  end

  def connecting_info_in_hash(data)
    data
    name_now = data[:name]
  end
end
