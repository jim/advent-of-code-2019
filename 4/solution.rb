require 'minitest'
require 'byebug'

def double_digits?(number)
  number =~ /(\d)\1/
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
    assert double_digits?("1122")
    refute double_digits?("123789")
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
  number = (109165..576723).map(&:to_s)
            .select { |n| only_ascending?(n) && double_digits?(n) }
            .size

  puts number
end
