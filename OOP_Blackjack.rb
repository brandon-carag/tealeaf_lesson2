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

  def get_total
    #sample card arr=[["H","3"],["C","Q"]]
    hand_total=0
    #Draw out second elements in the nested array

    face_values=player_cards.map{|card|card.kind} #THIS IS THE PROBLEM IN YOUR CODE
    #THE CREATION OF THE FACE_VALUES VARIABLE AND GETTING IT INTO THE PROPER FORMAT.
    #THE CODE CURRENTLY SITTING HERE IS CREATING A NEW ARRAY FROM THE PLAYER CARDS 
    #BASED ON THE KIND, IT'S UNCLEAR WHY MY METHOD DID NOT WORK.  THIS BEGS THE QUESTION
    #IF THE PROGRAM IS STRUCTURED IN THE WAY I DID, WHY DID IT NOT PASS IT IN?  MY SUSPICION
    #IS THAT THE PROCESSING IS TAKING PLACE IN AN ALTOGETHER DIFFERENT WAY.  IN THE SOLUTION
    #THE SOLUTION, IT SEEMS TO BE ITERATING THROUGH INDIVIDUAL CARDS AND CREATING THE
    #FACE VALUES ARRAY AS IF THE CARD IS THE PRIMARY OBJECT AS OPPOSED TO A COLLECTION
    #OF CARDS.  I THINK THIS IS THE KEY TAKEAWAY.  I THINK THE KEY TAKEAWAY IS THAT
    #WHEN ASKING IRB FOR INFORMATION ON AN ACTUAL DATABASE OBJECT, DON'T ASSUME IT
    #EXISTS IN THE DATA STRUCTURE YOU WOULD IMAGINE IT TO BE AGGREGATED IN, CONCEPTUALIZE
    #IT AS IT RETAINING THE SAME INSTANCE VARIABLES IT WAS CREATED WITH.

    #binding.pry
    #Perform ace count
    ace_count=face_values.select{|a|a=="A"}.size
    #Iterate through cards
    face_values.each do |x|
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
  attr_accessor :player_cards,:player_name
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

  def draw(card)
    combined=card.join
    puts "------"
    puts "| "+"#{combined}""|"
    puts "|    |"
    puts "|    |"
    puts "------"
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

class Gameplay
  attr_accessor :gamedeck,:player1,:dealer,:bet
  def initialize
    @gamedeck=Deck.new
    @player1=Player.new("Brandon",500)
    @dealer=Dealer.new("1000000")
    @bet=0
  end

#   def bust_check(player)
#     if player.get_total(player1.player_cards) >21
#       true
#     else
#       false
#     end
#   end


#   # def players_turn(player)
#   # while bust_check(player.get_total(player.player_cards))!=true
#   #   puts "Would you like to hit or stay?  1) hit or 2) stay?"
#   #   choice=gets.chomp
#   #   if choice=="1"
#   #     puts "You hit"
#   #     sleep(2)
#   #     draw_card(deck,player1_cards)
#   #     puts "You now have the following cards: #{player1_cards.keys}"
#   #     if bust_check(player1_cards)==true
#   #       puts "{player.name} busted"
#   #       exit
#   #     end
#   #   else
#   #     puts "You stayed"
#   #     break
#   # end


  def play
    puts "Welcome to the Blackjack Table."
    puts "How much would you like to bet?"
    @current_player=player1
    @bet=gets.chomp
    gamedeck.shuf
    #First Stage--Both Players get cards
    2.times {player1.get_card(gamedeck.deal_card)}
    2.times {dealer.get_card(gamedeck.deal_card)}
    puts "Your cards and total are:"
    puts player1.player_cards
    puts "____________"
    puts "The dealer cards are:"
    puts dealer.player_cards
    puts "The player's total is"
    puts player1.get_total
    puts "The dealer's total is"
    puts dealer.get_total
  end

# # #Blackjack Check
# #     if player1.get_total(player1.player_cards)==21
# #       puts "#{player.name} wins with Blackjack!"
# #     end
# #     if dealer.get_total(dealer.player_cards)==21
# #       puts "#{dealer.name} wins with Blackjack"
# #     end
#   # end

end

#Player's Turn
  # players_turn(current_player)

Gameplay.new.play




    



    #The reason why it appears you don't need a variable here is that when we're
    #runnign the get_totals function, it assumes we are already dealing with the 
    #instance variables for player1, and thus there's not really a need to pass
    #in a new parameter.  What was successful about this problem-solving
    #exercise? Persistence, using pry to try and draw out as much detail
    #as possible while debugging the problem.  It seems like it's easy to forget
    #the card is kind of like the fundamental unit.

    




    # binding.pry
    # puts player1.get_total(player_cards)

    # puts "The dealer's cards are"
    # puts dealer.player_cards
    




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