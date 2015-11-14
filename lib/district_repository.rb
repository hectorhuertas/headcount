require './lib/district'
require './lib/parser'
require 'pry'
class DistrictRepository
  attr_reader :districts, :enrollment_repo

  def initialize
    @enrollment_repo = EnrollmentRepo.new
    @districts = []
  end

  def load_data(data)
    # data = {
    #   :enrollment => {
    #     :kindergarten => "./test/data/kid.csv"
    #   }
    # Parser.parse(data[:enrollment][:kindergarten])
      enrollment_repo.load_data(data)
      # binding.pry
      create_districts_from_repos!
    #load all files
    #load all data
    # create_districts(Parser.get_names(data[:enrollment][:kindergarten]))
    #tell enroll_repo to load file
  end

  def create_districts(names_array)
    names_array.each do |name|
      districts << District.new({:name => name})
    end
  end

  def find_by_name(name)
    districts.find { |district| district.name == name.upcase}
  end

  def load_repos(repos)
    @enrollment_repo = repos[:enrollment]
    #create districts based of the names of the repos names
    create_districts_from_repos!
  end

  def create_districts_from_repos!
    d_names = @enrollment_repo.enrollments.map(&:name).uniq
    districts = d_names.map do |n|
      d = District.new(name:n)
      d.add_enrollments enrollment_repo.find_by_name(n)
      d
    end
    binding.pry
    @districts = districts
  end
end
