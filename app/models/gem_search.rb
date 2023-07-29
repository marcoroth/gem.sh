class GemSearch
  URL = "https://rubygems.org/api/v1/search/autocomplete"

  def self.search(query)
    return [] if query.blank?

    url = "#{URL}?query=#{query}"

    result = HTTParty.get(url)

    JSON.parse(result.response.body)
  end
end
