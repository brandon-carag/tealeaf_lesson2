require "rubygems"
require "pry"

module Carding
  def get_card(card)
    player_cards << card 
    # My original code; @player_cards << Deck.deal_card.  Why doesn't this work?
  end

  def bust?(hand)
    if hand.hand_total>21
      true
    else
      false
    end
  end

  def get_total(cards_array)
    #sample card arr=[["H","3"],["C","Q"]]
    hand_total=0
    #Draw out second elements in the nested array
    cards_array.collect! {|ind|ind[1]}
    #Perform ace count
    ace_count=cards_array.select{|a|a=="A"}.size
    #Iterate through cards
    cards_array.each do |x|
      if x=="J"|| x=="Q"||x=="K"
        hand_total+=10
      elsif x=="A"
        hand_total+=11
      else 
        hand_total+=x.to_i
      end
    end

    #Lastly, Ace Handling Logic
    if hand_total>21 &&ace_count>=1
      hand_total-=ace_count*10
    end
    hand_total
    end
end


class Player
  include Carding
  attr_accessor :player_cards
  def initialize(player,bank)
    @player_name=player
    @bank=bank
    @player_cards=[]
  end
end

class Dealer
  include Carding
  attr_accessor :player_cards
  def initialize(bank)
    @name="Dealer"
    @bank=1000000
    @player_cards=[]
  end
end


class Card
  attr_reader :suit,:kind
#Doesn't seem like there should be an initialized card
#How do I pass a complete set of cards into the card object for creation
  def initialize(suit,kind)
    @suit=suit
    @kind=kind
  end

  def pretty_output
    puts "The card is #{kind} of #{suit}"
  end

  def to_s 
    pretty_output
  end

  def find_suit
    case suit
      when'H' then "Hearts"
      when'D' then "Diamonds"
      when'S' then "Spades"
      when'C' then "Clubs"
    end
  end
end


class Deck
  attr_accessor :full_deck
  def initialize
    #Initialize with a full set of cards
    #This means initializing the instance variable @ deck
    #with a full set of cards

    #ANOTHER SET OF WORKING CODE
    suits=["C","D","H","S"]
    kinds=["2","3","4","5","6","7","8","9","10","J","Q","K","A"]
    @full_deck=[]
    suits.each do |suit| kinds.each do |kind| @full_deck << Card.new(suit,kind)
    end
    end
  
  end

  def shuf
    @full_deck.shuffle!
  end

  def deal_card
    @full_deck.pop
  end
end

test_deck=Deck.new
#binding.pry
# puts test_deck.full_deck


class Gameplay
  attr_accessor :gamedeck,:player1,:dealer,:bet
  def initialize
    @gamedeck=Deck.new
    @player1=Player.new("Brandon",500)
    @dealer=Dealer.new("1000000")
    @bet=0
  end


#   def hand_total_bust_check
#     #placeholder
#     #check for bust
#   end

#   def blackjack?()
#     hand_total=
#   end


  def play
    puts "Welcome to the Blackjack Table."
    puts "How much would you like to bet?"
    @bet=gets.chomp
    gamedeck.shuf
    #First Stage--Both Players get cards
    2.times {player1.get_card(gamedeck.deal_card)}
    2.times {dealer.get_card(gamedeck.deal_card)}
    puts "Your cards and total are:"
    puts player1.player_cards
    binding.pry
    puts player1.get_total(player_cards)

    puts "The dealer's cards are"
    puts dealer.player_cards
    




#     if @player1.player_cards.blackjack? && @dealer.player_cards.blackjack?
#       puts "You and the dealer both got Blackjack--it's a tie!"
#       break
#     elsif @player1.player_cards.blackjack?
#       puts "#{player_name} got Blackjack.  You win!"
#     elsif @dealer.player_cards.blackjack?
#       puts "#{player_name} got Blackjack.  You win!"
#     else 
#       puts "No one got Blackjack."
#     end
#     #Second Stage--Player given options to hit or stay
#     loop until @player_hand_total>21 || hit_or_stay="s"
#     puts "Do you want to hit or stay? 1) h 2) s"
#     dealcard
#     bust_check()

#     end


#     #Third Stage--Dealer draws till win or bust
#   end
#   exit
  end
end

Gameplay.new.play

#LECTURE NOTES

# Tips for OOP Blackjack
# 1. Have detailed requirements or specifications in writing
# 2. Extract major nouns > probably will map to classes--Player, card, deck, dealer
# 3. Extract major verbs > probably will map to instance methods
# 4. Group instance methods into classes
# 5. class variables and methods
# 6. compare with procedural

#Benefits of OOP
#1 Abstraction: 
#2 Encapsulation: It encapsulates certain behaviors 

#Priority # 1 When you look at Rails code, understand that it's Ruby powering the Rails magic.
#Keep in mind--you don't vf