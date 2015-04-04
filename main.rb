require 'colorize'
require './starter_kit'
require './triple'
require './table_t'
require './table_h'
require './robdd'
require 'pp'
require 'benchmark'

if ARGV[0]
  # give file names as a command line argument comma separated
  file_names = ARGV[0].strip.split(',')
  file_1 = "#{file_names[0]}.eblif"
  file_2 = "#{file_names[1]}.eblif"
else
  # read file based on command line input
  print "\nEnter 2 digits for file names (1,2): "
  file_names = gets.chomp.strip.split(',')
  file_1 = "node#{file_names[0]}.eblif"
  file_2 = "node#{file_names[1]}.eblif"
end

starter_kit = StarterKit.new(file_1)
# read eblif file and set the instance variables after parsing the eblif file
starter_kit.read_eblif
robdd_1 = ROBDD.new
robdd_1.build_func(starter_kit.on_set, 1, starter_kit.number_of_inputs)
t1 = robdd_1.t.t
u1 = t1.keys[-1]
num_inputs_1 = starter_kit.number_of_inputs
puts "ROBDD for #{file_1}: ".colorize(:blue)
pp(t1)

starter_kit = StarterKit.new(file_2)
starter_kit.read_eblif
robdd_2 = ROBDD.new
robdd_2.build_func(starter_kit.on_set, 1, starter_kit.number_of_inputs)
t2 = robdd_2.t.t
u2 = t2.keys[-1]
num_inputs_2 = starter_kit.number_of_inputs
puts "ROBDD for #{file_2}: ".colorize(:blue)
pp(t2)

terminal_node_var_num = [num_inputs_1, num_inputs_2].max + 1

t1[0] = { i: terminal_node_var_num, l: nil, h: nil }
t1[1] = { i: terminal_node_var_num, l: nil, h: nil }
t2[0] = { i: terminal_node_var_num, l: nil, h: nil }
t2[1] = { i: terminal_node_var_num, l: nil, h: nil }

time = Benchmark.realtime do
  final_robdd = ROBDD.new
  final_robdd.apply('and', u1, u2, t1, t2)
  puts "\nFinal ROBDD after AND operation: ".colorize(:green)
  pp(final_robdd.t.pretty_t)
end

puts "\nTime elapsed in AND operation: #{time*1000} milliseconds".colorize(:blue)
puts

time = Benchmark.realtime do
  final_robdd = ROBDD.new
  final_robdd.apply('or', u1, u2, t1, t2)
  puts "\nFinal ROBDD after OR operation: ".colorize(:green)
  pp(final_robdd.t.pretty_t)
end

puts "\nTime elapsed in OR operation: #{time*1000} milliseconds".colorize(:blue)
puts

time = Benchmark.realtime do
  final_robdd = ROBDD.new
  final_robdd.apply('xor', u1, u2, t1, t2)
  puts "\nFinal ROBDD after XOR operation: ".colorize(:green)
  pp(final_robdd.t.pretty_t)
end

puts "\nTime elapsed in XOR operation: #{time*1000} milliseconds".colorize(:blue)
puts
