require 'minitest'
require 'statewide_test'

class StatewideTestTest < Minitest::Test
  def test_it_exists
    assert StatewideTest
  end

  def test_it_capitalices_a_name
    st = StatewideTest.new({name: "one"})
    assert_equal "ONE", st.name
  end

  def test_it_capitalices_another_name
    st = StatewideTest.new({name: "two"})
    assert_equal "TWO", st.name
  end

end
