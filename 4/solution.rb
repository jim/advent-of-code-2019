require 'minitest'
require 'byebug'

def double_digits?(number)
  number =~ /(\d)\1/
end

def only_double_digits?(number)
  number.chars.slice_when { |a,b| a != b }.any? { |array| array.size == 2}
end

def only_ascending?(number)
  max = "0"
  number.chars.each do |char|
    if char < max
      return false
    elsif char > max
      max = char
    end
  end
  true
end

class PasswordTest < MiniTest::Test
  def test_double_digits
    refute double_digits?("1")
    refute double_digits?("123")
    assert double_digits?("11")
    assert double_digits?("111")
    assert double_digits?("112")
    assert double_digits?("122")
    assert double_digits?("1222")
    assert double_digits?("11122")
    refute double_digits?("123789")
  end

  def test_only_double_digits
    refute only_double_digits?("1")
    refute only_double_digits?("123")
    assert only_double_digits?("11")
    refute only_double_digits?("111")
    assert only_double_digits?("112")
    assert only_double_digits?("122")
    refute only_double_digits?("1222")
    assert only_double_digits?("11122")
    refute only_double_digits?("123789")
  end

  def test_only_ascending
    assert only_ascending?("1")
    assert only_ascending?("11")
    assert only_ascending?("12")
    assert only_ascending?("13")
    assert only_ascending?("133")
    assert only_ascending?("123456")
    refute only_ascending?("21")
    refute only_ascending?("121")
    refute only_ascending?("10")
    refute only_ascending?("223450")
  end
end

if MiniTest.run
  part1_answer = (109165..576723).map(&:to_s)
                                 .select { |n| only_ascending?(n) && double_digits?(n) }
                                 .size

  puts "Part 1 answer: #{part1_answer}"

  part2_answer = (109165..576723).map(&:to_s)
                                 .select { |n| only_ascending?(n) && only_double_digits?(n) }
                                 .size

  puts "Part 1 answer: #{part2_answer}"
end
