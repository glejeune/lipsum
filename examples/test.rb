$:.unshift( "../lib" )
require 'lipsum'

puts Lipsum.paragraphs![2].to_html
puts "----------------------------------------------------"
puts Lipsum.words[10].to_html
puts "----------------------------------------------------"
puts Lipsum.new(true).bytes[128].to_html
puts "----------------------------------------------------"
puts Lipsum.lists![3].to_html