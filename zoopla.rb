def get_zoopla(notify: true)
  p "Getting Zoopla..."
  doc = HTTParty.get("https://www.zoopla.co.uk/to-rent/property/edinburgh/?beds_min=2&include_shared_accommodation=false&price_frequency=per_month&price_max=1000&q=Edinburgh&results_sort=newest_listings&search_source=home")

  @parsed = Nokogiri::HTML(doc)
  ugly_data = @parsed.xpath('//ul[contains(@class, "listing-results")]/li/@data-listing-id')
  fetched_ids = ugly_data.map { |id| id.value }

  p "Found #{results.length} results"
  p results

  saved_ids = load_saved_ids

  p "Loading saved ids"
  p saved_ids

  new_ids = []
  fetched_ids.each do |fetched_id|
    found = false
    saved_ids.each do |saved_id|
      if fetched_id == saved_id
        found = true
        break
      end
    end

    if !found
      new_ids << fetched_id
    end
  end

  if notify && new_ids
    results = new_ids.map { |id| "https://www.zoopla.co.uk/to-rent/details/#{id}" }
    Mailer.new.send(results)
  end

  p "Saving"
  p new_ids

  save_ids(new_ids)
end

def load_saved_ids
  ids = []
  File.readlines("saves/zoopla.txt").each do |line|
    ids << line.strip
  end

  ids
end

def save_ids(ids)
  open("saves/zoopla.txt", "a") { |f|
    ids.each do |id|
      f.puts id
    end
  }
end
