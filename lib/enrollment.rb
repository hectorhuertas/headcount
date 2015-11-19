require_relative 'stat'
class Enrollment
  attr_reader :name

  def initialize(data)
    @name = data[:name].upcase
    # binding.pry
    @kindergarten_participation = data[:kindergarten_participation]
    @high_school_graduation = data[:high_school_graduation]
  end

  def kindergarten_participation_by_year
    Stat.truncating(@kindergarten_participation)
  end

  # def kindergarten_participation_in_year(year)
  #   Stat.round_decimal(@kindergarten_participation[year])
  # end

  def kindergarten_participation_in_year(year)
    kindergarten_participation_by_year[year]
  end

  def graduation_rate_by_year
    Stat.truncating(@high_school_graduation)
  end

  def graduation_rate_in_year(year)
    graduation_rate_by_year[year]
  end

  # def graduation_rate_in_year(year)
  #   Stat.round_decimal(@high_school_graduation[year])
  # end
end
