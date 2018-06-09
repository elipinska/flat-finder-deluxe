require "httparty"
require "nokogiri"

require "./mailer"
require "./zoopla"

zoopla_results = get_zoopla
