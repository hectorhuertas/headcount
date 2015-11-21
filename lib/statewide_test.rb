require_relative 'stat'
require_relative 'error'
class StatewideTest
  # attr_reader :name
  def initialize(data)
    @name = data[:name].upcase
    @data = data
  end

  def name
    @name
  end

  def proficient_by_grade(grade)
    if grade == 3
      answer = @data[:third_grade]
    elsif grade == 8
      answer = @data[:eighth_grade]
    else
      raise UnknownDataError
    end
    Stat.nested_truncating(answer)
  end

  def proficient_by_race_or_ethnicity(race)
    answer = case race
    when :asian            then @data[:Asian]
    when :black            then @data[:Black]
    when :pacific_islander then @data[:"Hawaian/Pacific Islander"]
    when :hispanic         then @data[:Hispanic]
    when :native_amerian   then @data[:"Native American"]
    when :two_or_more      then @data[:"Two or more"]
    when :white            then @data[:White]
    else
      fail UnknownDataError
    end
    Stat.nested_truncating(answer)
  end

  def valid_subjects
   [:math, :reading, :writing]
  end

  def proficient_for_subject_by_grade_in_year(subject, grade, year)
    fail UnknownDataError unless valid_subjects.include?(subject)
    # return 'N/A' if proficient_by_grade(grade) == 'N/A'
    proficient_by_grade(grade)[year][subject]
  end

  def proficient_for_subject_by_race_in_year(subject, race, year)
    fail UnknownDataError unless valid_subjects.include?(subject)
    # return 'N/A' if proficient_by_race_or_ethnicity(race) == 'N/A'
    proficient_by_race_or_ethnicity(race)[year][subject]
    # Stat.round_decimal(proficient_by_race_or_ethnicity(race)[year][subject])
  end
end
