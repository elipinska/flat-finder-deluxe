require "httparty"
require "nokogiri"

require "./mailer"
require "./zoopla"
require "./rightmove"

zoopla_results = get_zoopla
rightmove_results = get_rightmove

Mailer.new.send((zoopla_results << rightmove_results).flatten!)
