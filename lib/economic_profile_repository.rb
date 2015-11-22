require_relative 'ep_parser'
require_relative 'economic_profile'

class EconomicProfileRepository
  attr_reader :economic_profile

  def initialize(profiles = [])
    @economic_profile = profiles
  end

  def load_data(data)
    if data[:economic_profile]
      profiles_data = EpParser.profiles(data[:economic_profile])
      create_new_profiles(profiles_data)
    end
  end

  def find_by_name(name)
    economic_profile.find{|profile| profile.name == name.upcase}
  end

  def create_new_profiles(profiles_data)
    profiles_data.each do |profile_data|
      @economic_profile << EconomicProfile.new(profile_data)
    end
  end
end
