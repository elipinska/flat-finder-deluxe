def get_zoopla(notify: true)
  p "Getting Zoopla..."
  doc = HTTParty.get("https://www.zoopla.co.uk/to-rent/property/edinburgh/?beds_min=2&include_shared_accommodation=false&price_frequency=per_month&price_max=1000&q=Edinburgh&results_sort=newest_listings&search_source=home")

  @parsed = Nokogiri::HTML(doc)
  ids = @parsed.xpath('//ul[contains(@class, "listing-results")]/li/@data-listing-id').map {|id|
    id.value
  }
  dates = @parsed.xpath('//small[contains(text(),"Listed on")]').children.map {|el|
    suffix = el.text.strip.sub("Listed on \n ", "")
    newline_idx = suffix.index("\n")

    Date.parse(suffix[0..return_idx-1])
  }

  results_hash = {}
  dates.each_with_index {|date, index|
    if results_hash[date]
      results_hash[date] << ids[index]
    else
      results_hash[date] = [ids[index]]
    end
  }
  todays_results = results_hash[Date.today]

  p "No results found for today" unless todays_results

  if todays_results && notify
    results = todays_results.map { |id| "https://www.zoopla.co.uk/to-rent/details/#{id}" }
    Mailer.new.send(results)
  end
end
