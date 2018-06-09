require "httparty"
require "nokogiri"

p "Getting Zoopla..."
doc = HTTParty.get("https://www.zoopla.co.uk/to-rent/property/edinburgh/?beds_min=2&include_shared_accommodation=false&price_frequency=per_month&price_max=1000&q=Edinburgh&results_sort=newest_listings&search_source=home")

@parsed = Nokogiri::HTML(doc)
ugly_data = @parsed.xpath('//ul[contains(@class, "listing-results")]/li/@data-listing-id')
results = ugly_data.map { |id| "https://www.zoopla.co.uk/to-rent/details/#{id.value}" }
ids = ugly_data.map { |id| id.value }

p "Found #{results.length} results"
p results
