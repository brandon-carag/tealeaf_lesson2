require "rubygems"
require "pry"

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

module CardFunctionality
  attr_accessor :get_card

def get_card(card)
    player_cards << card 
    # My original code; @player_cards << Deck.deal_card
  end

end 


class Player
  include CardFunctionality
  attr_accessor :player_cards,:get_card
  def initialize(player,bank)
    @player_name=player
    @bank=bank
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
  attr_accessor :full_deck,:deal_card,:shuf
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
    @dealer=Player.new("Jonny Dealer","1000000")
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
    player1.get_card(gamedeck.deal_card)
    puts player1.player_cards
    
#     @dealer.get_card
#     @player1.get_card
#     @dealer.get_card

#     puts "You are showing the following cards: #{@player1.player_cards}"

#     puts "The dealer is showing the following cards #{"@dealer.player_cards}"

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

#_______________________________________________________________________________________
# class Card #What is a real life card?
#   attr_accessor :suit,:value

#   def initialize(s,v)
#     @suit=s
#     @value=v

#   def to_s
#     "This is the card! #{suit},#{value}"
#   end
    
#   end

# end

# class Deck
#   attr_accessor :cards
#   def initialize(num_decks)
#     @cards=[]
#     ['H','D','S','C'].each do |suit|
#       ['2','3','4','5','6','7','8','9','10','J','Q','K','A'].each do |face_value|
#         @cards << Card.new(suit, face_value)
#       end
#     end
#   scramble!
# end

# def scramble
#   cards.shuffle!

# def deal
#   cards.pop
# end

# class Player

# end

# class Dealer

# end

# class Blackjack
#   attr_accessor :player, :dealer, :deck
#   def initialize
#     @player=Player.net("Bob")
#     @dealer=Dealer.new
#     @deck=Deck.new
#   end

#   def run #within these, you 
#     deal_cards
#     show_flow
#     players.each do |player|
#       player_turn(player)
#     player_turn
#     dealer_turn
#     who_won?
#   end
# end