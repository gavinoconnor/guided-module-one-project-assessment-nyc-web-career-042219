require_relative '../config/environment'
require 'colorize'

def logo
puts "[... [......          [..                 [..   [.......            [..
     [..     [.       [..                 [..   [..    [.. [.       [..
     [..          [...[..  [..   [..    [.[. [. [..    [..      [...[..  [..
     [..    [.. [..   [.. [..  [.   [..   [..   [.......  [.. [..   [.. [..
     [..    [..[..    [.[..   [..... [..  [..   [..       [..[..    [.[..
     [..    [.. [..   [.. [.. [.          [..   [..       [.. [..   [.. [..
     [..    [..   [...[..  [..  [....      [..  [..       [..   [...[..  [..".colorize(:black)
end


puts "*"*85
logo
puts "*"*85
cli = CommandLineInterface.new
cli.greet
