#!/usr/bin/env ruby
# Week1 Day4   (Feb 2nd, 2017)
# CSV - Comma Separated Values

# read the CSV file into an array
require 'csv'
# url = "planet_express_logs.csv"
if ARGV[0]
  url = ARGV[0]
else
  puts "filename required!"
  exit(true)
end

#pe = CSV.foreach(url, headers: true, header_converters::symbol)

# class Delivery
class Delivery
  attr_accessor :destination, :what_got_shipped,
                :number_of_crates, :money_we_made,
                :namePilot
  def initialize(destination:, what_got_shipped:,
                number_of_crates:, money_we_made:)
    @destination       = destination
    @what_got_shipped  = what_got_shipped
    @number_of_crates  = number_of_crates.to_i
    @money_we_made     = money_we_made.to_i
    @namePilot         = set_name
  end
  def set_name
    nm = "undefined Pilot"
    case @destination
    when "Earth"    then nm = "Fry"
    when "Mars"     then nm = "Amy"
    when "Uranus"   then nm = "Bender"
    else                 nm = "Leela"
    end
  return nm
  end
  def bonus
    @money_we_made / 10
  end
end

def employees
  %w(Fry Amy Bender Leela)
end

class Parse
  def parse_data(file_name  )
    pe = CSV.foreach(file_name, headers: true, header_converters: :symbol)
    pe.collect {|row|  Delivery.new(row)}
  end
  def self.pilot_list (trips )
    trips.flat_map{|trip| trip.namePilot}.uniq
  end
  def self.planet_list (trips )
    trips.collect{|trip| trip.destination}.uniq
  end
  def self.planet_profits(planet, trips)
    foo = trips.select{|trip| trip.destination==planet}
    foo.collect{|trip| trip.money_we_made}.reduce(0){|sum,item| sum+=item}
  end
  def self.total_money(trips )
    monies = trips.flat_map{|trip| trip.money_we_made}
    monies.reduce(0){|sum,index| sum+=index}
  end
  def self.bonus_per_employee (trips,pilot )
    their_trips = trips.select{|trip| trip.namePilot==pilot}
    profit = their_trips.flat_map{|trip| trip.money_we_made}.reduce(0){|sum,n| sum+=n }
    profit * 0.1
  end
  def self.total_per_employee (trips,pilot )
    their_trips = trips.select{|trip| trip.namePilot==pilot}
    their_trips.flat_map{|trip| trip.money_we_made}.reduce(0){|sum,n| sum+=n }
  end
  def self.trips_per_pilot (trips,pilot )
    their_trips = trips.select{|trip| trip.namePilot==pilot}
    their_trips.length
  end
  def self.money_total(trips )
    trips.reduce(0) {|sum,trip| sum += trip.money_we_made}
  end
end

trips = Parse.new.parse_data(url )
pilots = Parse.pilot_list(trips )
planets = Parse.planet_list(trips )

# How much money did we make this week?
puts "Explorer Question 1"
puts "   How much money did we make this week?"
money = Parse.total_money(trips )
puts "   Total made this week is $#{money}"
puts ' '

puts "Exlorer Question 2"
puts "   How much of a bonus did each employee get?"
# pilots.each {|pilot|
#   their_trips = trips.select{|trip| trip.namePilot==pilot}
#   profit = their_trips.flat_map{|trip| trip.money_we_made}.reduce(0){|sum,n| sum+=n }
#   puts "   #{pilot} made #{profit * 0.1} bonus"
# }
pilots.each{|pilot|
  bonus = Parse.bonus_per_employee(trips,pilots )
  puts "   Total bonus for #{pilot} is $#{bonus}"
}
puts ' '

# How many trips did each employee pilot?
puts "Exlorer Question 3"
puts "   How many trips did each employee take? "
pilots.each{|pilot|
  n_trips = Parse.trips_per_pilot(trips,pilot )
  puts "   #{pilot} made #{n_trips}"
}
puts ' '

# How much money did we make broken down by planet?
puts "Exlorer Question 4"
puts "   How much money did we make, by planet?"
# planets = trips.collect{|trip| trip.destination}.uniq
# # puts planets
planets.each{|planet|
  profit = Parse.planet_profits(planet,trips )
  puts "   #{planet} made #{profit}"
}
puts ' '

# make a Parse class
puts "Adverture Question 1"
puts "   OK, I made a Parse class :-)"
puts ' '

# How much money did we make this week?
puts "Adverture Question 2"
puts "   How much money did we make this week?"
# trips = Parse.new.parse_data(url )
# total = trips.reduce(0) {|sum,trip| sum += trip.money_we_made}
total = Parse.money_total(trips )
puts "   Total earned is $#{total}"
puts ' '

# no puts in methods
puts "Epic Question 1"
puts "   OK, NO puts in any methods"
puts ' '

# no methods longer than 10 lines
puts "Epic Question 2"
puts "   OK, no methods longer than 10 lines"
puts " "

# make data_parser executable
puts "Epic Question 3"
puts "   OK, data_parser now executable via command line"
puts ' '

# All the above questions should have corresponding class methods in Parse
puts "Legendary Question 1"
puts "   OK, they are all now methods"
puts " "

# saves a new CSV
puts "Legendary Question 2"
if ARGV[1] && (ARGV[1]=='report')
  puts "   saving new.csv"
#  Pilot, Shipments, Total Revenue, Payment
#  Pilot, #shipments, Total, total_bonus
  # puts "   Pilot   nshipments   ntotal   nbonus"
  foo_list = trips.collect{|trip|
    foo = []
    pilot = trip.namePilot
    nshipments = Parse.trips_per_pilot(trips,pilot )
    ntotal     = Parse.total_per_employee(trips,pilot )
    nbonus     = Parse.bonus_per_employee(trips,pilot )
    # puts "   #{pilot} #{nshipments} #{ntotal} #{nbonus}"
    foo << pilot
    foo << nshipments
    foo << ntotal
    foo << nbonus
    # puts foo.to_s
    foo
  }
end

CSV.open("new.csv", "wb") { |csv|
  csv << ["Pilot", "Shipments", "Total Revenue", "Payment"]
  foo_list.each {|row|
    csv << row
  }
}
