require 'minitest'

Point = Struct.new(:x, :y) do
  def move(x, y)
    Point.new(self.x + x, self.y + y)
  end
  def inspect
    "{#{x},#{y}}"
  end
end

class Wire
  attr_accessor :points

  def initialize(&block)
    @points = [Point.new(0,0)]
    @cursor = Point.new(0,0)
    yield self if block_given?
  end

  def <<(path)
    direction = path[0]
    distance = path[1..-1].to_i
    x = y = 0
    case direction
    when "L"
      x = -1
    when "R"
      x = 1
    when "U"
      y = 1
    when "D"
      y = -1
    else
      raise "direction #{direction} not recognized"
    end
    distance.times do
      @cursor = @cursor.move(x, y)
      @points << @cursor
    end
  end

  def intersect(other_wire)
    self.points & other_wire.points
  end

  def self.from_paths(paths)
    new do |wire|
      paths.each { |path| wire << path }
    end
  end
end

def distance(point1, point2)
  (point1.x - point2.x).abs + (point1.y - point2.y).abs
end

def intersection(wire1_paths, wire2_paths)
  wire1 = Wire.from_paths(wire1_paths)
  wire2 = Wire.from_paths(wire2_paths)

  origin = Point.new(0,0)

  distances = wire1.intersect(wire2)
                .reject { |point| point == origin }
                .map { |point| distance(origin, point) }
                .sort

  return distances.first
end

class IntersectionTest < MiniTest::Test
  def test_intersection
    assert_equal 6, intersection(%w{R8 U5 L5 D3}, %w{U7 R6 D4 L4})
    assert_equal 159, intersection(%w{R75 D30 R83 U83 L12 D49 R71 U7 L72}, %w{U62 R66 U55 R34 D71 R55 D58 R83})
    assert_equal 135, intersection(%w{R98 U47 R26 D63 R33 U87 L62 D20 R33 U53 R51}, %w{U98 R91 D20 R16 D67 R40 U7 R15 U6 R7})
  end
end

if MiniTest.run
  input_path = File.expand_path("../input", __FILE__)
  lines = File.read(input_path).lines.map { |l| l.strip.split(",") }

  distance = intersection(*lines)
  puts "closest intersection is #{distance}"
end