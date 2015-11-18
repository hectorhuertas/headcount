class EconomicProfile
  def initialize(data)
    @name = data[:name].upcase
    @data = data
  end

  def name
    @name
  end


end
