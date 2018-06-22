require 'catpix'

class Player
    attr_accessor :player_health, :player_attack, :player_defense, :player_inventory, :baron_health, :player_name, :player_pokemon
    
    def initialize(player_name, pokemon)
        @player_health = 20
        @player_attack = 10
        @player_defense = 10
        @baron_health = 30
        @player_name = player_name
        @player_pokemon = pokemon

        @player_inventory = []
        
        puts "\n" + player_name + "'s health is #{player_health}. " + player_name + "'s attack is #{player_attack} and their defense is #{player_defense}."

        set_baron_health
    end

    def check_inventory
        puts @player_inventory
    end

    def take(item, stat='')
        unless @player_inventory.include? item
            @player_inventory.push(item)
            if stat == 'player_attack'
                @player_attack += 5
            elsif stat == 'player_defense'
                @player_defense += 5
            end
        end
        puts "The following items are in your inventory: #{@player_inventory}."
    end

    def remove(item, stat='')
        if @player_inventory.include? item
            @player_inventory.delete(item)
            if stat == 'player_attack'
                @player_attack -= 5
            elsif stat == 'player_defense'
                @player_defense -= 5
            end
        end
        puts "The following items are in your inventory: #{@player_inventory}."
    end

    def set_baron_health
        if player_attack > 19 && player_defense >14
            @baron_health = 20
        elsif player_attack > 19 || player_defense > 14
            @baron_health = 25
        else
            @baron_health = 30
        end
    end

    def attack_baron
        # Generate random number between 0 and 6
        # and round down to either 0 or 5
        # store resulting integer in variable roll
        player_roll = rand(6).floor

        player_damage = player_roll * 3
        puts "\nYou attack the BARON for #{player_damage} damage."

        @baron_health -= player_damage

        if @baron_health <= 0
        abort("\nYou defeated the BARON! Run the file to play again.")
        else
        puts "BARON's health: #{@baron_health}hp"
        defend_baron
        end
    end
 
    def defend_baron
    # Generate random number between 0 and 6
    # and round down to either 0 or 5
    # store resulting integer in variable roll
        baron_roll = rand(6).floor

        baron_damage = baron_roll * 3
        puts "\nBARON attacks you for #{baron_damage} damage."

        @player_health -= baron_damage

        if @player_health <= 0
            abort("THE BARON has killed you. Run the file again to enact vengeance.")
        else
            puts "Your health: #{@player_health}hp"
            puts "\nContinue attacking? Y/N"
            choice = $stdin.gets.chomp.upcase
            if choice == 'Y'
                attack_baron
            else
                puts "Well if you won't attack him then he's bound to murdalize you. Game Over."
                you_lose
            end
        end
    end
end

class Game
    attr_accessor :player_health, :player_attack, :player_defense
    
    def initialize
        puts "Oh, hey. What's your name again? > "
        player_name = $stdin.gets.chomp
        puts "And are you a boy or a girl? > "
        gender = $stdin.gets.chomp
        puts "Lastly, who did you pick as your starter Pokemon in Pokemon Red/Blue? > "
        pokemon = $stdin.gets.chomp
        @dead_trogdor = false
        start(player_name, pokemon)
    end

    def prompt
        puts "\nEnter command > "
    end

    def start(player_name, pokemon)
        @player = Player.new(player_name, pokemon)
        room_1(true)
    end

    def set_baron_health
        @player.set_baron_health
    end

    def is_trogdor_dead
        if @dead_trogdor
            return "DEAD "
        else 
            return ""
        end
    end

    def load_pic(url)
        Catpix::print_image url,
            :limit_x => 0.5,
            :limit_y => 0.5,
            :center_x => true,
            :center_y => true,
            :resolution => "high"
    end

    def room_1(first_entry)
        if first_entry == true
            load_pic('img/dungeonintro.png')
        end
        puts "\nYou awake to find yourself in a dark, musty room. In this room are an empty FLAGON, a suspicious looking HAYSTACK, and a sharp ROCK. Visible exits are NORTH, WEST, and " + is_trogdor_dead + "TROGDOR.\n"
        prompt
        answer = $stdin.gets.chomp.upcase
        case answer
        when 'NORTH'
            room_2(true)
        when 'WEST'
            room_3(true)
        when 'TROGDOR'
            load_pic("img/trogdor.jpg")
            if @player.player_pokemon.downcase == 'charmander'
                puts "What?!? CHARMANDER is evolving! CHARMANDER evolved into CHARIZARD! CHARIZARD and TROGDOR duke it out and it's pretty close, but CHARIZARD emerges as the victor, saving you from certain death. Nice.\n"
                @dead_trogdor = true
                room_1(false)
            elsif @player.player_pokemon.downcase == 'squirtle'
                puts "SQUIRTLE used Bubble! It's inexplicably super effective! TROGDOR has fainted!"
                @dead_trogdor = true
                room_1(false)
            elsif @player.player_pokemon.downcase == 'bulbasaur'
                puts "Little BULBASAUR tried its hardest, but it got burned to a crisp by The Burninator. You monster. How could you do this to poor, sweet BULBASAUR?"
                you_lose
            end
            puts "\nSeriously? You had to know you'd lose a fight with The Burninator. You're dead.\n"
            you_lose
        when 'FLAGON'
            puts "\nIt seems like there yet be some moonshine left in this here flagon!\n"
                @player.take("flagon", "player_attack")
                puts "\nYour attack power has increased by 5, because you're an aggressive drunk. Your attack is now #{@player.player_attack}.\n"
                room_1(false)
        when 'HAYSTACK'
            puts "\n'Suspicious: def. An object which, in the context of this game, will almost certainly kill you.' You have been murdalized. By a haystack.\n"
            you_lose
        when 'ROCK'
            @player.take("rock")
            puts "\nYou have put the rock into your inventory. Can't imagine why, but you'll do what you feel is best, I suppose.\n"
            room_1(false)
        when 'QUIT'
            quit
        else
            error_message
            room_1(false)
        end
    end

    def room_2(first_entry)
        if first_entry == true
            load_pic("img/kitchen.png")
        end
        puts "\nLooks like the kitchen. Inside, you see a truly enormous carving KNIFE, some CHICKEN, and a bottle of BOURBON. Exits are NORTH, SOUTH, and SOUTHEAST.\n"
        prompt
        answer = $stdin.gets.chomp.upcase
        case answer
        when 'NORTH'
            room_4(true)
        when 'SOUTH'
            room_1(true)
        when 'SOUTHEAST'
            room_3(true)
            when 'KNIFE'
                @player.take("knife", "player_attack")
                puts "\nGood thinking grabbing the stabby looking thing. Your attack power has increased by 5. Your attack is now #{@player.player_attack}.\n"
                room_2(false)
            when 'CHICKEN'
                @player.take("chicken", "player_defense")
                puts "\nYour defense power has increased because... chicken. Your defense is now #{@player.player_defense}.\n"
                room_2(false)
            when 'BOURBON'
                @player.take("bourbon", "player_attack")
                puts "\nDrunk Brayan left this bourbon here! Ye drinketh it. YE ARE EVEN MORE AGGRO. Your attack is now #{@player.player_attack}.\n"
                room_2(false)
            when 'QUIT'
                quit
            else
                error_message
                room_2(false)
        end
    end

    def room_3(first_entry)
        if first_entry == true
            load_pic("img/bathroom.jpg")
        end
        puts "\nYou've reached the bathroom, and are confronted by an odour most foule. You see some BANDAGES, ASPIRIN, and a TOASTER floating inside of a bathtub. Exits are KANYE'S DAUGHTER and EAST.\n"
        prompt
        answer = $stdin.gets.chomp.upcase
        case answer
        when 'NORTH WEST'
            room_2(true)
        when 'EAST'
            room_1(true)
        when 'BANDAGES'
            @player.take("bandages", "player_defense")
            puts "\nYour ability to not bleed to death has increased. Defense +5. Your defense is now #{@player.player_defense}.\n"
            room_3(false)
        when 'ASPIRIN'
            @player.take("aspirin")
            puts "\nDrunk Brayan must have left these here. You take them, because f*** Drunk Brayan.\n"
            room_3(false)
        when 'TOASTER'
            puts "\nYou should have checked whether that toaster was plugged in. Spoiler Alert: it was. Ye are verily dead.\n"
            you_lose
        when 'QUIT'
            quit
        else
            error_message
            room_3(false)
        end

    end

    def room_4(first_entry)
        if first_entry == true
            load_pic("img/antechamber.jpg")
        end
        puts "\nYou're in some sort of weird antechamber. There doesn't appear to be anything in here, except... OMG, is that DRUNK BRAYAN?!. Exits are NORTH, SOUTH, and DRUNK BRAYAN.\n"
        prompt
        answer = $stdin.gets.chomp.upcase
        case answer
        when 'NORTH'
            room_5
        when 'SOUTH'
            room_2(true)
        when 'DRUNK BRAYAN'
            load_pic("img/brayan.jpg")
            puts "\nYou're confronted by a surly, extremely intoxicated DRUNK BRAYAN. He asks you for his ASPIRIN or, barring that, the password. You've... got the password... right?\n"
            password = gets.chomp
                if password == "trapeloadmin"
                    you_win
                elsif password.downcase == "aspirin" and not @player.player_inventory.include? "aspirin"
                    puts "What are you, drunk? You don't have any aspirin. DRUNK BRAYAN flies into an incoherent rage and kills you."
                    you_lose
                elsif password.downcase == "aspirin"
                    @player.remove("aspirin", "player_defense")
                    puts "Really dumb move. Now you're vulnerable to alcohol. Defense -5. Your defense is now #{@player.player_defense}."
                    room_4(false)
                else
                    puts "\nThat's not the password! Uh-oh... DRUNK BRAYAN looks angry. He killed you. Better luck next time.\n"
                    you_lose
                end
        when 'QUIT'
            quit
        else
            error_message
            room_4(false)
        end
    end

    def room_5
        trigger_boss_battle
    end

    def trigger_boss_battle
        load_pic("img/baron.jpg")

        puts "You've encountered the fearsome BARON VON JOEL FROM IDG :^). You must roll the dice
        \nto determine your fate. You lose if your health reaches 0.
        \nYour health is #{@player.player_health}.
        \nYour attack is #{@player.player_attack}. Your defense is #{@player.player_defense}."
        set_baron_health
        @player.attack_baron
    end

    def you_win
        abort("Congrats" + @player.player_name + "You've escaped the dungeon in (mostly) one piece! Congrats! Run the file to play again.")
    end

    def you_lose
        puts "Game Over. Do you want to try again? Y/N > "
        answer = $stdin.gets.chomp
        case answer
        when 'y'
            start(@player.player_name, @player.player_pokemon)
        when 'n'
            quit
        end
    end

    def error_message
        puts "That's not a valid choice. Try again."
    end

    def quit
        abort("Giving up, eh? I get it. Drunk Brayan is pretty scary. If you want to try again, I'll be waiting...")
    end
end

Game.new
