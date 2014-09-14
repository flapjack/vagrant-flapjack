#!/usr/bin/env ruby

require 'pry'

pancake = {
  :kind        => 'Food',
  :aka         => 'flapjack (US)',
  :description => 'A pancake is a flat cake, often thin, and round, prepared from a starch-based batter and cooked on a hot surface such as a griddle or frying pan. (Wikipedia)'
}

puts "To inspect the pancake object just created, enter 'pancake' into the pry promp and hit return:"

binding.pry

# To exit the pry prompt, enter 'quit' or ctrl-d

