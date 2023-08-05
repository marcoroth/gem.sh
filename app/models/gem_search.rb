class GemSearch
  def self.search(query)
    return [] if query.blank?

    Gems.search(query)
  end
end
