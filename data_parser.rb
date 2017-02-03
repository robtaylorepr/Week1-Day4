#!/usr/bin/env ruby
# Week1 Day4   (Feb 2nd, 2017)
# CSV - Comma Separated Values

# Header
# Destination, What got shipped, Number of crates, Money we made


# read the CSV file into an array
require 'csv'
# url = "planet_express_logs.csv"

if ARGV[0]
  url = ARGV[0]
else
  puts "filename required!"
  exit(true)
end

pe = CSV.foreach(url, headers: true, header_converters:
:symbol)

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
    @namePilot         = self.set_name
  end
  def set_name
    nm = "undefined Pilot"
    case @destination
    when "Earth"    then nm = "Fry"
    when "Mars"     then nm = "Amy"
    when "Uranis"   then nm = "Bender"
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

class Pilot
  attr_accessor     :name, :earned_total, :bonus_total, :trip_total
  def initialize(name, earned_total=0, bonus_total=0, trip_total=0 )
    @earned_total = earned_total
    @bonus_total  = bonus_total
    @trip_total   = trip_total
    @name         = name
  end
end

# For each employee, create a Pilot instance
pilots = []
employees.each {|employee|
    pilots << Pilot.new(employee)
}

# How much money did we make this week?
puts ' '
puts "How much money did we make this week?"
trips = pe.collect {|row|
  Delivery.new(row)
}
total = trips.reduce(0) {|sum,trip|
  sum += trip.money_we_made
}
puts "Total earned is $#{total}"

# How much of a bonus did each employee get? (bonuses are paid to employees who pilot the Planet Express)
puts ' '
puts "How much of a bonus did each employee get?"
# For each employee
total_bonus = 0
employees.each {|employee|
  # Select trips with that employee
  trips.select {|trip|
    #puts "#{employee} $#{trip.bonus} trip to #{@destination}"
    #cumulate each trips bonus
    total_bonus += trip.bonus
  }
  # Reduce the bonus to a total
  puts "#{employee} total bonus = $#{total_bonus}"
}

# How many trips did each employee pilot?
trips.each {|trip|
  pilot_name = trip.namePilot
  #puts "Pilot name is #{pilot_name}"
  p_instance = pilots.detect {|pilot|
    pilot.name == pilot_name
  }
  if p_instance
    #puts "   Yes, I found the matching pilot"
    p_instance.earned_total += trip.money_we_made
    p_instance.bonus_total  += trip.bonus
    p_instance.trip_total   += 1
    #puts "      earned #{p_instance.earned_total}"
    #puts "      bonus  #{p_instance.bonus_total}"
    #puts "      trips  #{p_instance.trip_total}"
  else
    #puts "      No, I did not find any matching pilots"
  end
  p_instance
}

# How many trips did each employee take?
puts ' '
puts "How many trips did each employee take? "
pilots.each {|pilot|
  puts "#{pilot.name} made #{pilot.trip_total}"
}

class Parse
  attr_accessor :file_name, :parse_data
  def initialize
    @file_name = ''
  end
  def parse_data(file_name )
    @file_name = file_name
  end
end

# How much money did we make broken down by planet?
puts ' '
puts "How much money did we make, by planet?"
# first, create a hash of planets & money
planets = Hash.new
trips.each {|trip|
  td = trip.destination
  tm = trip.money_we_made
  planets[td] ? planets[td]+=tm : planets[td] = tm
}
puts planets









# Define and use your Delivery class to represent each shipment
#   see Delivery class above, and usage
