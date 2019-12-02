require 'minitest'

def fuel_required(mass)
  mass / 3 - 2 # integer division truncates, so no need to round down
end

class FuelTest < MiniTest::Test               # The Test Suite
  def test_examples
    assert_equal 2, fuel_required(12)
    assert_equal 2, fuel_required(14)
    assert_equal 654, fuel_required(1969)
    assert_equal 33583, fuel_required(100756)
  end
end

if MiniTest.run
  input_path = File.expand_path("../input", __FILE__)
  masses = File.read(input_path).lines.map(&:strip).map(&:to_i)
  fuel_required = masses.inject(0) { |sum, mass| sum + fuel_required(mass) }
  puts "total fuel required: #{fuel_required}"
end