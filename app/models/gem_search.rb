class GemSearch
  URL = "https://rubygems.org/api/v1/search/autocomplete"

  def self.search(query)
    url = "#{URL}?query=#{query}"

    HTTParty.get(url)
  end
end
