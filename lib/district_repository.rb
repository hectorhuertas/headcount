require_relative 'district'
require_relative 'parser'
require_relative 'enrollment_repository'
require_relative 'statewide_test_repository'
require 'pry'
class DistrictRepository
  attr_reader :districts, :enrollment_repo, :state_repo

  def initialize
    @enrollment_repo = EnrollmentRepository.new
    @state_repo = StatewideTestRepository.new
    @districts = []
  end

  def load_data(data)
      enrollment_repo.load_data(data) if data[:enrollment]
      # binding.pry
      state_repo.load_data(data) if data[:statewide_testing]

      create_districts_from_repos!

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
    d_names = []
    d_names << @enrollment_repo.enrollments.map(&:name).uniq
    d_names << @state_repo.tests.map(&:name).uniq
    districts = d_names.flatten.map do |n|
      d = District.new(name:n)
      # binding.pry
      d.add_enrollment enrollment_repo.find_by_name(n)
      d.add_tests state_repo.find_by_name(n)
      d
    end
    @districts = districts
  end

  def find_all_matching(string)
    districts.select { |district| district.name.match(/#{string.upcase}/)}
  end
end
