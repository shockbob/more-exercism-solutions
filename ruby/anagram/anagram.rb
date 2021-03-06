=begin
Write your code for the 'Anagram' exercise in this file. Make the tests in
`anagram_test.rb` pass.

To get started with TDD, see the `README.md` file in your
`ruby/anagram` directory.
=end

class Anagram
  def initialize(target)
    @target = target
  end

  def normalize(str)
    str.downcase.split("").sort
  end

  def match(candidates)
    normalized = normalize(@target) 
    candidates.select{|candidate| candidate.downcase != @target.downcase && normalize(candidate) == normalized}
  end
end

