require 'rest-client'
require 'pry'
require 'json'

class CommandLineInterface

# Greet the User.
  def greet
    puts "Welcome to Ticket Pick!"
    puts "*" * 23
    puts "Please enter your name:"
    self.find_or_create_user
  end

# If new user, create them.
  def find_or_create_user
    user_name = gets.chomp
    user = User.find_by(name: user_name)
    if user != nil
      puts "Welcome back, #{user.name}!"
      self.user_action(user)
    else
      user = User.create(name: user_name)
      puts "Thanks for joining!"
      self.user_action(user)
    end
  end

#Present menu options.
  def user_action(user)
    puts "-- Search Tickets, Post Tickets, or Update/Delete Profile?"
    user_response(user)
  end

# Apply Search/Post/Update helper functions.
  def user_response(user)
    post_or_search = gets.chomp
    if post_or_search.downcase == "search"
      self.search_response
    elsif post_or_search.downcase == "post"
      self.post_ticket_response
    elsif post_or_search.downcase == "update"
      self.update_user(user)
    else
      self.greet
  end
end

# Update user helper function
  def update_user(user)
    puts "What would you like to update: Name, Location, Age, Gender, Relationship Status?"
    puts " Or would you like to delete your profile?"
    update = gets.chomp
    if update.downcase == "name"
      puts "Please update your name:"
      name = gets.chomp
      user.update(name: name)
    elsif update.downcase == "location"
      puts "Please update your location:"
      location = gets.chomp
      user.update(location: location)
    elsif update.downcase == "age"
      puts "Please update your age:"
      age = gets.chomp
      user.update(age: age)
    elsif update.downcase == "gender"
      puts "Please update your gender:"
      gender = gets.chomp
      user.update(gender: gender)
    elsif update.downcase == "status"
      status = gets.chomp
      user.relationship_status(relationship_status: status)
    elsif update.downcase == "delete"
      puts "Are you sure? Y/N"
      existence = gets.chomp
      if existence.downcase == "y"
        user.delete
        "Deleted, have a nice day!"
      end
    else
      self.greet
    end
  end

# Post-response: user will enter ticket information:
  # def post_ticket_response
  #   puts "Please enter your full name:"
  #   post_ticket_name = gets.chomp
  #   puts "Please enter the venue:"
  #   post_ticket_venue = gets.chomp
  #   puts "Please enter the band name:"
  #   post_ticket_band = gets.chomp
  #   Ticket.create(post_ticket_name, , Ticket.band_name)
  # end

# Search-responses, user can select by venue, user, or city.

  def search_response
    puts "-- Search by Venue, User, or City:"
    venue_or_user = gets.chomp
      if venue_or_user.downcase == "venue"
        self.search_venue
      elsif venue_or_user.downcase == "user"
        self.search_user
      elsif venue_or_user.downcase == "city"
      else
        self.greet
      end
  end

# Venue search helper function:
  def search_venue
    puts "-- Enter Venue Name, or 'all' for current list of venues:"
    venue_input = gets.chomp
      if venue_input.downcase == "all"
        self.venue_by_number
      elsif
        venue_input = Venue.all.find_by(name: name_input)
        self.venue_by_name(venue_input)
      else
        self.greet
      end
  end

# User search function, can choose between direct input and list of all users.
  def search_user
    puts "-- Enter User Name, or 'all' for a current list of ticketholders."
    name_input = gets.chomp
      if name_input.downcase == "all"
        self.user_by_number
      elsif
        name_input = User.all.find_by(name: name_input)
        self.user_by_name(name_input)
      else
        self.greet
      end
    end

# Name search helper function.
    def user_by_name(name_input)
      name_info = name_input.tickets.first.user_id
      name_with_band = name_input.tickets.first.band_name
      puts "-- Looks like #{User.find(name_info).name} has a ticket for #{name_with_band}."
      puts "*"*60
      puts "-- Would you like to message #{User.find(name_info).name}? Y/N"
      response = gets.chomp
        if
          response.downcase == "y"
          puts "-- We're working to let you message them soon!"
          puts " "
          self.greet
        else
          self.greet
    end
  end

# List numbered names helper function
    def user_by_number
      all_names = User.all.find_each.with_index do |person, index|
         puts "#{index + 1}. #{person.name}"
         all_names
        end
          puts "/n" + "*" * 23 + "/n"
          puts "-- Enter a User's number for more info:"
          num_select = gets.chomp.to_i
            if num_select == User.all.find_by(id: num_select).id
              ticket_info = User.all.find_by(id: num_select).tickets.first.band_name
              user_name = User.all.find_by(id: num_select).name
              puts "#{user_name} has the following tickets: #{ticket_info}"
            else
              puts "It looks like that user doesn't have any current tickets."
            end
    end


# Venue name search helper function
    def venue_by_name
      venue_input = Venue.find_by(name: venue_input)
      venue_with_band = venue_input.tickets.first.band_name
        if venue_input
            puts "-- Looks like we have a ticket for #{venue_with_band} at #{venue_input.name}!"
            puts "*"*60
            puts "-- Would you like to view the ticketholder? Y/N"
            view_ticketholder = gets.chomp
              if view_ticketholder.downcase == "y"
                user_id = venue_input.tickets.first.user_id
              puts "#{User.find(user_id).name} has an extra ticket. We're working to let you message them soon!"
              puts " "
              else
                self.greet
              end
        end
        self.greet
    end

# List numbered venues helper function
    def venue_by_number
        all_venues = Venue.all.find_each.with_index do |venue, index|
           puts "#{index + 1}. #{venue.name}"
           all_venues
          end
            puts "\n #{"*" * 23}"
            puts "-- Enter a Venue's number for more info:"
            num_select = gets.chomp.to_i
              if num_select == Venue.all.find_by(id: num_select).id
                ticket_info = Venue.all.find_by(id: num_select).tickets.first.band_name
                venue_name = Venue.all.find_by(id: num_select).name
                puts "#{venue_name} has the following shows: #{ticket_info}."
                puts "Would you like to see who has tickets? Y/N"
                view_ticketholder = gets.chomp
                  if view_ticketholder.downcase == "y"
                    user_id = Venue.all.find_by(id: num_select).tickets.first.user_id
                  puts "-- #{User.find(user_id).name} has an extra ticket. We're working to let you message them soon!"
                  puts " "
              else
                puts "It looks like there aren't any extra tickets to upcoming shows at #{venue_name}."
              end
              self.greet
            end
      end


    # def search_city
    # end


end



    #list of venues - should return a list of venues, with the band_names
    #list of users - should return users who have tickets, with band_names

    #list of tickets

  #   response = RestClient.get("https://api.songkick.com/api/3.0/artists/379603/gigography.json?apikey=nu80rqJInvFVVDU4")
  #   string = response.body
  #   data = JSON.parse(string)
  #   binding.pry
  # end
