require "rubygems"
require "pry"

#===========================================================================
module Carding
  attr_accessor :player_cards,:player_name
  def get_card(card)
    player_cards << card 
    # My original code; @player_cards << Deck.deal_card.  Why doesn't this work?
  end


  def blackjack?
    if get_total==21
      true
    else
      false
    end
  end

  def bust?(hand)
    if player.get_total>21
      true
    else
      false
    end
  end

  def get_total
    #sample card array=[["H","3"],["C","Q"]]
    hand_total=0
    #Draw out second elements in the nested array

    face_values=player_cards.map{|card|card.kind} #NOTE TO SELF: THIS WAS THE PROBLEM IN YOUR CODE
    #THE CREATION OF THE FACE_VALUES VARIABLE AND GETTING IT INTO THE PROPER FORMAT.
    #THE CODE CURRENTLY SITTING HERE IS CREATING A NEW ARRAY FROM THE PLAYER CARDS 
    #BASED ON THE KIND, IT'S UNCLEAR WHY MY METHOD DID NOT WORK.  THIS BEGS THE QUESTION
    #IF THE PROGRAM IS STRUCTURED IN THE WAY I DID, WHY DID IT NOT PASS IT IN?  MY SUSPICION
    #IS THAT THE PROCESSING IS TAKING PLACE IN AN ALTOGETHER DIFFERENT WAY.  IN THE SOLUTION, 
    #IT SEEMS TO BE ITERATING THROUGH INDIVIDUAL CARDS AND CREATING THE
    #FACE VALUES ARRAY AS IF THE CARD IS THE PRIMARY OBJECT AS OPPOSED TO A COLLECTION
    #OF CARDS.  I THINK THIS IS THE KEY TAKEAWAY.  I THINK THE KEY TAKEAWAY IS THAT
    #WHEN ASKING IRB FOR INFORMATION ON AN ACTUAL OBJECT, DON'T ASSUME IT
    #EXISTS IN THE DATA STRUCTURE YOU WOULD IMAGINE IT TO BE AGGREGATED IN, CONCEPTUALIZE
    #IT AS IT RETAINING THE SAME INSTANCE VARIABLES IT WAS CREATED WITH.

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


  def show_player_cards
    player_cards.map do|card|
    puts "------"
      if card.kind.to_s.length>=2
      puts "| "+"#{card.kind}#{card.suit}"+"|"
      else
      puts "| "+"#{card.kind}#{card.suit}"+" |"
      end
    puts "|    |"
    puts "|    |"
    puts "------"
    end
  end

end

#===========================================================================
class Player
  include Carding
  def initialize(player,bank)
    @player_name=player
    @bank=bank
    @player_cards=[]
  end
end

#===========================================================================
class Dealer
  include Carding
  def initialize(bank)
    @player_name="Dealer"
    @bank=1000000
    @player_cards=[]
  end
end

#===========================================================================
class Card
  attr_reader :suit,:kind
#Doesn't seem like there should be an initialized card
#How do I pass a complete set of cards into the card object for creation
  def initialize(suit,kind)
    @suit=suit
    @kind=kind
  end

  def show_card
    puts "The card is #{kind} of #{suit}"
    draw
  end

  def draw
    puts "------"
    puts "| "+"#{kind}#{suit}"+" |"
    puts "|    |"
    puts "|    |"
    puts "------"
  end

  # def find_suit
  #   case suit
  #     when'H' then "Hearts"
  #     when'D' then "Diamonds"
  #     when'S' then "Spades"
  #     when'C' then "Clubs"
  #   end
  # end
end

#===========================================================================
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

#===========================================================================
class Gameplay
  attr_accessor :gamedeck,:player1,:dealer,:bet
  def initialize
    @gamedeck=Deck.new
    @player1=Player.new("Brandon",500)
    @dealer=Dealer.new("1000000")
    @bet=0
  end

  def bust_check(player)
    if player.get_total >21
      puts "#{player.player_name} busted!"
      gameover
      true
    else
      false
    end
  end

  def gameover
    puts "The game is over.  Would you like to play again? 1) yes 2) no"
    response=gets.chomp
    if response=="1"
      Gameplay.new.play
    elsif response=="2"
      exit
    else
      "You entered an invalid option"
    end
  end

  def deal_first_hand
      2.times {player1.get_card(gamedeck.deal_card)}
      player1.show_player_cards 
      puts "#{player1.player_name}'s cards are shown above.  The total is #{player1.get_total}"
      2.times {dealer.get_card(gamedeck.deal_card)}
      dealer.show_player_cards
      puts "The dealer's cards are shown above.  The dealer's total is #{dealer.get_total}"
        #Blackjack Check
      if player1.blackjack? && dealer.blackjack?
        puts "It's a tie!"
        gameover
      elsif player1.blackjack?
        puts "#{player1.player_name} wins with Blackjack!"
        gameover
      elsif dealer.blackjack?
        puts "#{dealer.player_name} wins with Blackjack"
        gameover
      end
        puts "\nNo one got blackjack on the first deal."
  end

  def player_turn(player)
    while bust_check(player) !=true
      puts "Would you like to hit or stay?  1) hit or 2) stay?"
      choice=gets.chomp

      if choice=="1"
        player.get_card(gamedeck.deal_card)
        puts player.show_player_cards
        puts "You hit.  Your new cards are shown above.  Your new total is #{player.get_total}"
      elsif choice=="2"
        puts "You stayed" 
        break
      else
        puts "You entered an invalid choice"
      end

    end
  end

  def dealer_turn
    if dealer.get_total>player1.get_total
      puts "You lose.  You should have hit"
      gameover
    end
    while dealer.get_total<=17 || dealer.get_total<player1.get_total
      puts "It's now the dealer's turn, and he is drawing more cards..."
      dealer.get_card(gamedeck.deal_card)
      dealer.show_player_cards
      puts "The dealer now holds the cards above.  His total is #{dealer.get_total}"
      sleep(2)

      if bust_check(dealer)==true
        puts "The dealer busted and you win!"
        gameover
      elsif dealer.get_total>player1.get_total 
        puts "It's a tie!  Your card total matched with the dealers."
        gameover        
      elsif dealer.get_total>player1.get_total
        puts "The dealer won and you lost."
        gameover
      end
    end
  end





#===========================================================================
  def play
    gamedeck.shuf
    puts "Welcome to the Blackjack Table.  How much would you like to bet?"
    @bet=gets.chomp
    

    deal_first_hand
    player_turn(player1)
    dealer_turn
  end
end

#===========================================================================
#Call the first game
Gameplay.new.play

#===========================================================================
#OOP LECTURE NOTES

    # #Both Players dealt initial cards
    # 2.times {player1.get_card(gamedeck.deal_card)}
    # player1.show_player_cards 
    # puts "The player's cards are shown above.  The player's total is #{player1.get_total}"
    # 2.times {dealer.get_card(gamedeck.deal_card)}
    # dealer.show_player_cards
    # puts "The dealer's cards are shown above.  The dealer's total is #{dealer.get_total}"
  
    
    #Player and Dealer's Turns
    



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