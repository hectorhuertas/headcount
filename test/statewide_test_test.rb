require 'minitest'
require 'statewide_test'

class StatewideTestTest < Minitest::Test
  def test_it_exists
    assert StatewideTest
  end

  def test_it_capitalices_a_name
    st = StatewideTest.new(name: 'one')
    assert_equal 'ONE', st.name
  end

  def test_it_capitalices_another_name
    st = StatewideTest.new(name: 'two')
    assert_equal 'TWO', st.name
  end

  def test_proficient_by_grade_3
    st = StatewideTest.new(name: 'two',
                           third_grade: { 2008 => { math: 0.697, reading: 0.703, writing: 0.501 },
                                          2009 => { math: 0.691, reading: 0.726, writing: 0.536 } })
    expected ={ 2008 => { math: 0.697, reading: 0.703, writing: 0.501 },
                2009 => { math: 0.691, reading: 0.726, writing: 0.536 } }
    assert_equal 'TWO', st.name
    assert_equal expected, st.proficient_by_grade(3)
  end

  def test_proficient_by_grade_3_na
    st = StatewideTest.new(name: 'two',
                           third_grade: { 2008 => { math: 'N/A', reading: 0.703, writing: 0.501 },
                                          2009 => { math: 0.691, reading: 'N/A', writing: 0.536 } })
    expected ={ 2008 => { math: 'N/A', reading: 0.703, writing: 0.501 },
                2009 => { math: 0.691, reading: 'N/A', writing: 0.536 } }
    assert_equal 'TWO', st.name
    assert_equal expected, st.proficient_by_grade(3)
  end

  def test_proficient_by_grade_3_full_na
    st = StatewideTest.new(name: 'two',
                           third_grade: { 2008 => { math: 'N/A', reading: 'N/A', writing: 'N/A' },
                                          2009 => { math: 0.691, reading: 'N/A', writing: 0.536 } })
    expected ={ 2008 => { math: 'N/A', reading: 'N/A', writing: 'N/A' },
                2009 => { math: 0.691, reading: 'N/A', writing: 0.536 } }
    assert_equal 'TWO', st.name
    assert_equal expected, st.proficient_by_grade(3)
  end

  def test_proficient_by_grade_3_truncated
    st = StatewideTest.new(name: 'two',
                           third_grade: { 2008 => { math: 0.69749, reading: 0.70339, writing: 0.5013 },
                                          2009 => { math: 0.691492, reading: 0.726203, writing: 0.5365 } })
    expected ={ 2008 => { math: 0.697, reading: 0.703, writing: 0.501 },
                2009 => { math: 0.691, reading: 0.726, writing: 0.536 } }
    assert_equal 'TWO', st.name
    assert_equal expected, st.proficient_by_grade(3)
  end

  def test_proficient_by_grade_8
    st = StatewideTest.new(name: 'two', eighth_grade: { 2008 => { math: 0.697 } } )
    expected ={ 2008 => { math: 0.697 } }
    assert_equal 'TWO', st.name
    assert_equal expected, st.proficient_by_grade(8)
  end

  def test_proficient_by_grade_8_truncated
    st = StatewideTest.new(name: 'two', eighth_grade: { 2008 => { math: 0.38282 } } )
    expected ={ 2008 => { math: 0.382 } }
    assert_equal 'TWO', st.name
    assert_equal expected, st.proficient_by_grade(8)
  end

  def test_proficient_by_race_or_ethnicity
    st = StatewideTest.new(name: 'two', Asian: {2011 => { math: 0.709, reading: 0.6, writing: 0.2 }} )
    expected ={ 2011 => { math: 0.709, reading: 0.6, writing: 0.2 } }
    assert_equal 'TWO', st.name
    assert_equal expected, st.proficient_by_race_or_ethnicity(:asian)
  end

  def test_proficient_by_race_or_ethnicity_truncated
    st = StatewideTest.new(name: 'two', Asian: {2011 => { math: 0.709, reading: 0.6383, writing: 0.2394 }} )
    expected ={ 2011 => { math: 0.709, reading: 0.638, writing: 0.239 } }
    assert_equal 'TWO', st.name
    assert_equal expected, st.proficient_by_race_or_ethnicity(:asian)
  end

  def test_proficient_for_subject_by_grade_in_year
    st = StatewideTest.new(name: 'two', eighth_grade: { 2008 => { math: 0.697 } } )
    expected = 0.697
    assert_equal 'TWO', st.name
    assert_equal expected, st.proficient_for_subject_by_grade_in_year(:math, 8, 2008)
  end

  def test_proficient_for_subject_by_grade_in_year_truncate
    st = StatewideTest.new(name: 'two', eighth_grade: { 2008 => { math: 0.697888 } } )
    expected = 0.697
    assert_equal 'TWO', st.name
    assert_equal expected, st.proficient_for_subject_by_grade_in_year(:math, 8, 2008)
  end

  def test_proficient_for_subject_by_grade_in_year_na
    st = StatewideTest.new(name: 'two', eighth_grade: { 2008 => { math: 'N/A' } } )
    expected = 'N/A'
    assert_equal 'TWO', st.name
    assert_equal expected, st.proficient_for_subject_by_grade_in_year(:math, 8, 2008)
  end

  def test_proficient_for_subject_by_race_in_year
    st = StatewideTest.new(name: 'two', Asian: {2011 => { math: 0.709, reading: 0.6, writing: 0.2 }} )
    expected = 0.6
    assert_equal 'TWO', st.name
    assert_equal expected, st.proficient_for_subject_by_race_in_year(:reading, :asian, 2011)
  end

  def test_proficient_for_subject_by_race_in_year_na
    st = StatewideTest.new(name: 'two', Asian: {2011 => { math: 0.709, reading: 'N/A', writing: 0.2 }} )
    expected = 'N/A'
    assert_equal 'TWO', st.name
    assert_equal expected, st.proficient_for_subject_by_race_in_year(:reading, :asian, 2011)
  end

  def test_proficient_for_subject_by_race_in_year_with_truncated
    st = StatewideTest.new(name: 'two', Asian: {2011 => { math: 0.709, reading: 0.60458, writing: 0.2 }} )
    expected = 0.604
    assert_equal 'TWO', st.name
    assert_equal expected, st.proficient_for_subject_by_race_in_year(:reading, :asian, 2011)
  end
end
