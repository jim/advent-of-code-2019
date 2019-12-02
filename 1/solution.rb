require 'minitest'

def fuel_required(mass)
  mass / 3 - 2 # integer division truncates, so no need to round down
end

def fuel_required_including_self(mass)
  total = 0
  loop do
    mass = fuel_required(mass)
    break if mass <= 0
    total += mass
  end
  total
end

class FuelTest < MiniTest::Test
  def test_fuel_required
    assert_equal 2, fuel_required(12)
    assert_equal 2, fuel_required(14)
    assert_equal 654, fuel_required(1969)
    assert_equal 33583, fuel_required(100756)
  end

  def test_fuel_required_including_self
    assert_equal 2, fuel_required_including_self(14)
    assert_equal 966, fuel_required_including_self(1969)
    assert_equal 50346, fuel_required_including_self(100756)
  end
end

if MiniTest.run
  input_path = File.expand_path("../input", __FILE__)
  masses = File.read(input_path).lines.map(&:strip).map(&:to_i)

  fuel_required = masses.inject(0) { |sum, mass| sum + fuel_required(mass) }
  puts "total fuel required: #{fuel_required}"

  recalculated_fuel_required = masses.inject(0) { |sum, mass| sum + fuel_required_including_self(mass) }
  puts "total fuel required taking its own weight into account: #{recalculated_fuel_required}"
end