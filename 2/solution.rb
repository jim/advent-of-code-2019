require 'minitest'

def compute(program)
  program = program.dup
  index = 0

  loop do
    op, input_position1, input_position2, output_position = program[index, 4]
    case op
    when 1
      program[output_position] = program[input_position1] + program[input_position2]
    when 2
      program[output_position] = program[input_position1] * program[input_position2]
    when 99
      break
    else
      raise "opcode #{op} not understood"
    end
    index += 4
  end
  
  program
end

class ComputeTest < MiniTest::Test
  def test_compute
    assert_equal [2,0,0,0,99], compute([1,0,0,0,99])
    assert_equal [2,3,0,6,99], compute([2,3,0,3,99])
    assert_equal [2,4,4,5,99,9801], compute([2,4,4,5,99,0])
    assert_equal [30,1,1,4,2,5,6,0,99], compute([1,1,1,4,99,5,6,0,99])
  end
end

if MiniTest.run
  input_path = File.expand_path("../input", __FILE__)
  program = File.read(input_path).strip.split(",").map(&:to_i)

  program[1] = 12
  program[2] = 2

  result = compute(program)
  puts "final state: #{result}"
end