require_relative 'ep_parser'
require_relative 'economic_profile'

class EconomicProfileRepository
  attr_reader :profiles

  def initialize(profiles = [])
    @profiles = profiles
  end

  def load_data(data)
    profiles_data = EpParser.profiles(data[:economic_profile])
    create_new_profiles(profiles_data)
  end

  def find_by_name(name)
    tests.find{|test| test.name == name.upcase}
  end


  def create_new_STtests(profiles_data)
    profiles_data.each do |profile|
      @profile << EconomicProfile.new(profile)
    end
  end
end
