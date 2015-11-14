require 'minitest/autorun'
require './lib/district_repository'

class DistrictRepositoryTest < Minitest::Test
  def test_it_exists
    assert DistrictRepository
  end

  def test_it_loads_data
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/data/kid.csv"
      }
    })
    assert dr.find_by_name("COLORADO")
  end

  def test_find_by_name
    dr = DistrictRepository.new
    d = District.new({:name => 'Colorado'})
    dr.districts << d

    assert_equal d, dr.find_by_name('COLORADO')
  end

  def test_does_not_find_name
    dr = DistrictRepository.new

    assert_equal nil, dr.find_by_name('ALABAMA')
  end

  def test_creates_districts_from_a_name
    dr = DistrictRepository.new
    dr.create_districts(['COLoradO'])

    assert_equal 'COLORADO', dr.find_by_name('colorado').name
  end

  def test_it_find_names_case_insensitive
    dr = DistrictRepository.new
    dr.create_districts(['Colorado', 'alabama', 'WISCONSIN'])

    assert_equal 'COLORADO', dr.find_by_name('Colorado').name
    assert_equal 'ALABAMA', dr.find_by_name('Alabama').name
    assert_equal 'WISCONSIN', dr.find_by_name('Wisconsin').name

  end

  def test_creates_districts_from_multiple_names
    dr = DistrictRepository.new
    dr.create_districts(['Colorado', 'Alabama', 'Wisconsin'])

    assert_equal 'COLORADO', dr.find_by_name('Colorado').name
    assert_equal 'ALABAMA', dr.find_by_name('Alabama').name
    assert_equal 'WISCONSIN', dr.find_by_name('Wisconsin').name
  end

  # def test_it_finds_all_matches_from_a_substring
  #   dr = DistrictRepository.new
  #   dr.create_districts(['Colorado', 'Alabama', 'Alticola'])
  #   founded = dr.find_all_matching('col')
  # end
end
