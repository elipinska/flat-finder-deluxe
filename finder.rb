require "httparty"
require "nokogiri"

require "./mailer"
require "./zoopla"

get_zoopla(notify: false)
