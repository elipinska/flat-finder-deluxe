require "httparty"
require "nokogiri"

def get_rightmove
  p "Getting Rightmove..."
  doc = HTTParty.get("https://www.rightmove.co.uk/property-to-rent/find.html?searchType=RENT&locationIdentifier=REGION%5E475&insId=1&radius=0.0&minPrice=&maxPrice=800&maxBedrooms=2&displayPropertyType=&maxDaysSinceAdded=1&sortByPriceDescending=&_includeLetAgreed=off&primaryDisplayPropertyType=&secondaryDisplayPropertyType=&oldDisplayPropertyType=&oldPrimaryDisplayPropertyType=&letType=&letFurnishType=&includeLetAgreed=false&dontShow=houseShare")
  @parsed = Nokogiri::HTML(doc)
  rel_links = @parsed.xpath("//div[contains(@class, 'l-searchResult') and contains(@class, 'is-list') and not(contains(@class,'is-hidden'))]//a[contains(@class, 'propertyCard-img-link')]//@href")

  p "No results found" unless rel_links

  rel_links.nil? ? [] : rel_links.map{|link| "http://www.rightmove.co.uk#{link.value}"}
end
