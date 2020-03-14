# Set up for the application and database. DO NOT CHANGE. #############################
require "sequel"                                                                      #
connection_string = ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/development.sqlite3"  #
DB = Sequel.connect(connection_string)                                                #
#######################################################################################

# Database schema - this should reflect your domain model
DB.create_table! :bars do
  primary_key :id
  String :name
  String :description, text: true
<<<<<<< HEAD
  String :item1, text: true
  String :item2, text: true
  String :item3, text: true
  String :item4, text: true
  String :location, text: true
=======
  String :item1
  String :item2
  String :item3
  String :item4
  String :location
>>>>>>> d681e152182cb79c188a0bcf5b4886cf531c24ea
end
DB.create_table! :ratings do
  primary_key :id
  foreign_key :bar_id
  foreign_key :user_id
<<<<<<< HEAD
  Boolean :rated
=======
>>>>>>> d681e152182cb79c188a0bcf5b4886cf531c24ea
  Float :staff
  Float :environment
  Float :drinks
  String :comments, text: true
end
DB.create_table! :users do
  primary_key :id
  String :username
  String :name
  String :phone
  String :email
  String :password
end

# Insert initial (seed) data
bars_table = DB.from(:bars)

bars_table.insert(name: "Sidetrack",
                    description: "Behomoth gay club drawing a diverse crowd, serving up slushy drinks & known for showtune nights",
                    item1: "8 separate bars to get drinks from",
                    item2: "Large outdoor rooftop patio to enjoy slushy drinks on warm summer days",
                    item3: "Showtunes night 3 times a week",
                    item4: "Weekly drag events like Beyonce Night, or Pop Rocks",
                    location: "3349 N Halsted St, Chicago, IL 60657")

bars_table.insert(name: "Roscoe's Tavern",
                    description: "Chicago's premiere gay bar",
                    item1: "Dance floor with a live DJ on weekends",
                    item2: "Exclusive drag shows with queens from RuPaul's Drag Race",
                    item3: "Late night food menu",
                    item4: "$1 Beers for Sunday Funday drinking",
                    location: "3356 N Halsted St, Chicago, IL 60657")
bars_table.insert(name: "Scarlet Bar",
                    description: "Boystown's dance club with drink specials",
                    item1: "Dance floor with a live DJ",
                    item2: "Liquid brunch on Sundays",
                    item3: "Weekly frat night on Thirsty Thursdays",
                    item4: "Bottle service available",
                    location: "3320 N Halsted St, Chicago, IL 60657")
bars_table.insert(name: "North End",
                    description: "Longtime, low-key gay sports bar with flat-screen TVs, darts, billiards & occasional karaoke",
                    item1: "Halsted's only gay sports bar",
                    item2: "Pool table and darts to play",
                    item3: "Weekly events including Get Smashed with Bonnie",
                    item4: "Large beers available to quench your thirst",
                    location: "3733 N Halsted St, Chicago, IL 60613")
bars_table.insert(name: "Charlie's",
                    description: "Western-themed Boystown bar & dance club with drag shows, karaoke, bingo & late-night hours",
                    item1: "Late night dancing - open til 4am or later every night",
                    item2: "Drag shows throughout the week",
                    item3: "Line dancing night on Saturdays",
                    item4: "No cover til after midnight",
                    location: "3726 North Broadway, Chicago, IL 60613")
                    
