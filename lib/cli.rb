require 'rest-client'
require 'pry'
require 'json'
require 'colorize'

class CommandLineInterface
attr_accessor :user, :venue, :band_name, :claimed

# Greet the User.
  def greet
    puts "Welcome to Ticket Pick!".colorize(:blue)
    puts "*" * 23
    puts "Please enter your name:".colorize(:blue)
    self.find_or_create_user
  end

# If new user, create them.
  def find_or_create_user
    user_name = gets.chomp
    self.user = User.find_by(name: user_name)
    if user != nil
      puts "Welcome back, #{user.name}!".colorize(:blue)
      self.user_menu(user)
    else
      user = User.create(name: user_name)
      puts "Thanks for joining!".colorize(:blue)
      self.user_menu(user)
    end
  end


#Present menu options.
  def user_menu(user)
    puts "-- Search, Post Tickets, Update/Delete Profile, or Exit?".colorize(:blue)
    user_response(user)
  end

# Apply Search/Post/Update helper functions.
  def user_response(user)
    post_or_search = gets.chomp
    if post_or_search.downcase == "search"
      self.search_response(user)
    elsif post_or_search.downcase == "post"
      self.create_ticket(user)
    elsif post_or_search.downcase == "update"
      self.update_user(user)
    elsif post_or_search.downcase == "delete"
      self.update_user(user)
    elsif post_or_search.downcase == "exit"
      exit
    else
      self.user_menu(user)
  end
end

# Create/post ticket
  def create_ticket(user)
    puts "Please enter the venue:".colorize(:blue)
    ticket_venue = gets.chomp
    venue_name = Venue.all.find_by(name: ticket_venue)
    puts "Please enter the band name:".colorize(:blue)
    ticket_band = gets.chomp
    band = ticket_band
    Ticket.create(self.user.id = user.id, venue_name = venue_name.id, band = band_name, claimed=false)
  end

# Update user helper function
  def update_user(user)
    puts "What would you like to update: Name, Location, Age, Gender, Relationship Status?".colorize(:blue)
    puts " Or would you like to delete your profile?".colorize(:blue)
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
      puts "Please update your status:"
      status = gets.chomp
      user.update(relationship_status: status)
    elsif update.downcase == "delete"
      puts "Are you sure? Y/N"
      existence = gets.chomp
      if existence.downcase == "y"
        user.delete
        puts "Deleted, have a nice day!"
      end
      self.user_menu(user)
    else
      self.user_menu(user)
    end
  end


# Search-responses, user can select by venue, user, or city.
  def search_response(user)
    puts "-- Search by Venue, User, or City:".colorize(:blue)
    venue_or_user = gets.chomp
      if venue_or_user.downcase == "venue"
        self.search_venue
      elsif venue_or_user.downcase == "user"
        self.search_user(user)
      elsif venue_or_user.downcase == "city"
      else
        self.user_menu(user)
      end
  end

# Venue search helper function:
  def search_venue
    puts "-- Enter Venue Name, or 'all' for current list of venues:".colorize(:blue)
    venue_input = gets.chomp
      if venue_input.downcase == "all"
        self.venue_by_number
      elsif
        venue_input = Venue.all.find_by(name: name_input)
        self.venue_by_name(venue_input)
      else
        self.user_menu(user)
      end
  end

# User search function, can choose between direct input and list of all users.
  def search_user(user)
    puts "-- Enter User Name, or 'all' for a current list of ticketholders.".colorize(:blue)
    name_input = gets.chomp
      if name_input.downcase == "all"
        self.user_by_number
      elsif
        name_input = User.all.find_by(name: name_input)
        self.user_by_name(name_input)
      else
        self.user_menu(user)
      end
    end

# Name search helper function.
    def user_by_name(name_input)
      name_info = name_input.tickets.first.user_id
      name_with_band = name_input.tickets.first.band_name
      puts "-- Looks like #{User.find(name_info).name} has a ticket for #{name_with_band}.".colorize(:blue)
      puts "*"*60
      puts "-- Would you like to message #{User.find(name_info).name}? Y/N".colorize(:blue)
      response = gets.chomp
        if
          response.downcase == "y"
          puts "-- We're working to let you message them soon!".colorize(:blue)
          puts " "
          self.user_menu(user)
        else
          self.user_menu(user)
    end
  end

# List numbered names helper function
    def user_by_number
      all_names = User.all.find_each.with_index do |person, index|
         puts "#{index + 1}. #{person.name}"
         all_names
        end
          puts "\n #{"*" * 23}"
          puts "-- Enter a User's number for more info:".colorize(:blue)
          num_select = gets.chomp.to_i
            if num_select == User.all.find_by(id: num_select).id
              ticket_info = User.all.find_by(id: num_select).tickets.first.band_name
              user_name = User.all.find_by(id: num_select).name
              puts "#{user_name} has the following tickets: #{ticket_info}"
              puts "-- Would you like to message #{user_name}? Y/N".colorize(:blue)
              response = gets.chomp
                if
                  response.downcase == "y"
                  puts "-- We're working to let you message them soon!".colorize(:blue)
                  puts " "
                  self.user_menu(user)
                else
                  self.user_menu(user)
                end
            else
              puts "It looks like that user doesn't have any current tickets.".colorize(:blue)
            end
            self.user_menu(self.user)
    end


# Venue name search helper function
    def venue_by_name
      venue_input = Venue.find_by(name: venue_input)
      venue_with_band = venue_input.tickets.first.band_name
        if venue_input
            puts "-- Looks like we have a ticket for #{venue_with_band} at #{venue_input.name}!"
            puts "*"*60
            puts "-- Would you like to view the ticketholder? Y/N".colorize(:blue)
            view_ticketholder = gets.chomp
              if view_ticketholder.downcase == "y"
                user_id = venue_input.tickets.first.user_id
              puts "#{User.find(user_id).name} has an extra ticket. We're working to let you message them soon!".colorize(:blue)
              puts " "
              else
                self.user_menu(user)
              end
        end
        self.user_menu(user)
    end

# List numbered venues helper function
    def venue_by_number
        all_venues = Venue.all.find_each.with_index do |venue, index|
           puts "#{index + 1}. #{venue.name}"
           all_venues
          end
            puts "\n #{"*" * 23}"
            puts "-- Enter a Venue's number for more info:".colorize(:blue)
            num_select = gets.chomp.to_i
              if num_select == Venue.all.find_by(id: num_select).id
                ticket_info = Venue.all.find_by(id: num_select).tickets.first.band_name
                venue_name = Venue.all.find_by(id: num_select).name
                puts "#{venue_name} has the following shows: #{ticket_info}.".colorize(:blue)
                puts "Would you like to see who has tickets? Y/N".colorize(:blue)
                view_ticketholder = gets.chomp
                  if view_ticketholder.downcase == "y"
                    user_id = Venue.all.find_by(id: num_select).tickets.first.user_id
                  puts "-- #{User.find(user_id).name} has an extra ticket. We're working to let you message them soon!".colorize(:blue)
                  puts " "
              else
                puts "It looks like there aren't any extra tickets to upcoming shows at #{venue_name}.".colorize(:blue)
              end
              self.user_menu(user)
            end
      end


    # def search_city
    # end


end


    #list of venues - should return a list of venues, with the band_names

    #list of users - should return users who have tickets, with band_names
  #   def list_of_users
  #     user_list = {}
  #     User.all.map do |user, ticket|
  #       user_list << user[ticket]
  #       user_list
  #   end
  # end

  #   response = RestClient.get("https://api.songkick.com/api/3.0/artists/379603/gigography.json?apikey=nu80rqJInvFVVDU4")
  #   string = response.body
  #   data = JSON.parse(string)
  #   binding.pry
  # end
