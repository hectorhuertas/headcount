class Enrollment
  attr_reader :name

  def initialize(data)
    @name = data[:name].upcase
    # binding.pry
    @kindergarten_participation = data[:kindergarten_participation]
    @high_school_graduation = data[:high_school_graduation]
  end

  def kindergarten_participation_by_year
    @kindergarten_participation
  end

  def kindergarten_participation_in_year(year)
    @kindergarten_participation[year].round(3)
  end

  def graduation_rate_by_year
    @high_school_graduation
  end

  def graduation_rate_in_year(year)
    @high_school_graduation[year].round(3)
  end
end
