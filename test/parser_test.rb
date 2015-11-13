require 'minitest/autorun'
require './lib/parser'

class ParserTest < Minitest::Test
  def test_it_exists
    assert Parser
  end

  def test_it_brings_file_in
    skip
    info = Parser.parse([:kindergarten, "./test/data/kid.csv"])
    result = {:name=>"Colorado", :kindergarten=>{2007=>0.395}}
    assert_equal result, info[0]
  end

end
