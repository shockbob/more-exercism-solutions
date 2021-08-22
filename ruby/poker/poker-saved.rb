=begin
Write your code for the 'Poker' exercise in this file. Make the tests in
`poker_test.rb` pass.

To get started with TDD, see the `README.md` file in your
`ruby/poker` directory.
=end
require 'set'
$ranks = {"2"=>2,"3"=>3,"4"=>4,"5"=>5,"6"=>6,
         "7"=>7,"8"=>8,"9"=>9,"10"=>10,"J"=>11,"Q"=>12,"K"=>13,"A"=>14}

class HandRecognizer
  def getMatchers(hand)
     hash = Hash.new(0)
     hand.collect{|card| card[0..-2]}.each{|rank| hash[rank] = hash[rank]+1}
     hash.select{|k,v| v > 1}
  end
  def matchers_value(matchers)
    if matchers.values.size == 1
       key = matchers.keys[0]
       return $ranks[key]
    else
       values_set = Set.new(matchers.values)
       if (values_set.size == 1 && matchers.size == 2)
         keys = matchers.keys.collect{|k| $ranks[k]}.sort
         return keys[1] * 15 + keys[0]
       else
          sum = 0
          matchers.values.sort.reverse.each do |value| 
             raw_value = matchers.select{|k,v| v == value}.collect{|k,v| $ranks[k]}.first
          sum = 15 * sum + raw_value
        end
        return sum
      end
    end
  end
  def rank(card)
    $ranks[card[0..-2]]
  end

  def value_hand(hand)
    -1
  end
end

class PatternRecognizer < HandRecognizer
  def initialize(pattern,addon)
    @pattern = pattern
    @addon = addon
  end
  def value_hand(hand)
    matchers = getMatchers(hand)
    if (matchers.values == @pattern)
       @addon + matchers_value(matchers)
    else
      -1
    end
  end
end

class StraightFlushRecognizer < HandRecognizer

  def value_hand(hand)
    flush_value = FlushRecognizer.new().value_hand(hand)
    if (flush_value > -1)
      straight_value = StraightRecognizer.new().value_hand(hand)
      if (straight_value > -1)
         8000 + hand.collect{|card| rank(card)}.max
      else
        -1
      end
    else
      -1
    end
  end
end


class FlushRecognizer < HandRecognizer
  def value_hand(hand)
    suits = hand.collect{|card| card[-1]}
    suit_set = Set.new(suits)
    if (suit_set.size == 1)
      5000 + hand.collect{|card| rank(card)}.max
    else
      -1
    end
  end
end

class StraightRecognizer < HandRecognizer
  def initialize()
     ranks = [14,2,3,4,5,6,7,8,9,10,11,12,13,14] 
     @straights = (0..9).collect{|i| Set.new(ranks[i,5])}
  end

  def value_hand(hand)
    ranks = hand.collect{|card| rank(card)}
     ranks = Set.new(ranks)
     if (@straights.include?(ranks))
         if (ranks.include?(14) && ranks.include?(2))
             ranks = ranks - [14]
         end
         4000 + ranks.max
     else
        -1
      end 
  end
end


class HighestCard < HandRecognizer
  def value_hand(hand)
     hand.collect{|card| rank(card)}.sum
  end
end

$recognizers = [
  StraightFlushRecognizer.new,
  PatternRecognizer.new([4],7000),
  PatternRecognizer.new([3,2],6000),
  FlushRecognizer.new,
  StraightRecognizer.new,
  PatternRecognizer.new([3],3000),
  PatternRecognizer.new([2,2],2000),
  PatternRecognizer.new([2],1000),
  HighestCard.new]

class Poker
  def initialize(hands)
    @hands = hands
  end

  def value_hand(hand)
    $recognizers.collect{|recognizer| recognizer.value_hand(hand)}
        .select{|val| val != -1}
        .first
  end

  def best_hands
     hash = Hash.new{|h,k| h[k] = [] }
     @hands.collect{|hand| hash[value_hand(hand)] << hand}
     hash[hash.keys.max]
  end
    
  def best_hand
    if @hands.size == 1
      return [@hands[0]]
    end
    best_hands
  end
end

