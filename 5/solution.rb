require 'minitest'
require 'byebug'

def compute(program, io_in: $stdin, io_out: $stdout)
  index = 0

  loop do
    raw_opcode = program[index]

    break if raw_opcode == 99

    opcode = raw_opcode.to_s.chars.map(&:to_i)

    op = opcode.pop
    opcode.pop # this can only ever be zero, so ignore it
    param_modes = opcode.reverse

    case op
    when 1
      input1, input2, output_position = program[index + 1, 3]
      if param_modes.fetch(0, 0) == 0
        input1 = program[input1]
      end
      if param_modes.fetch(1, 0) == 0
        input2 = program[input2] 
      end
      program[output_position] = input1 + input2
      index += 4
    when 2
      input1, input2, output_position = program[index + 1, 3]
      if param_modes.fetch(0, 0) == 0
        input1 = program[input1]
      end
      if param_modes.fetch(1, 0) == 0
        input2 = program[input2] 
      end
      program[output_position] = input1 * input2
      index += 4
    when 3
      output_position = program[index + 1]
      io_out.print "? "
      input = io_in.gets.strip.to_i
      program[output_position] = input
      index += 2
    when 4
      value = program[index + 1]
      if param_modes.fetch(0, 0) == 0
        value = program[value] 
      end

      io_out.puts value
      index += 2
    else
      raise "opcode #{op} not understood"
    end
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

  def test_opcodes_3_and_4
    echo = [3,0,4,0,99]
    input = StringIO.new("45\n")
    output = StringIO.new
    compute(echo, io_in: input, io_out: output)

    output.rewind
    assert_equal "? 45\n", output.read
  end

  def test_parameter_modes
    program = [1002,4,3,4,33]
    output = StringIO.new
    compute(program, io_out: output)
  end
end

if MiniTest.run
  input_path = File.expand_path("../input", __FILE__)
  program = File.read(input_path).strip.split(",").map(&:to_i)

  input = StringIO.new("1\n")
  $running = true
  compute(program)
end