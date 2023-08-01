# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://gem.sh"

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path "/" and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options = {})
  #        (default options are used if you don"t specify)
  #
  # Defaults: priority: 0.5, changefreq: "weekly", lastmod: Time.now, host: default_host
  #
  # Examples:
  #
  # Add "/articles"
  #
  #   add articles_path, priority: 0.7, changefreq: "daily"
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), lastmod: article.updated_at
  #   end

  add "/", changefreq: "daily"

  Gem::Specification.all.sort_by { |gem| gem.name }.each do |gem|
    add(gem_version_path(gem.name, gem.version), changefreq: "weekly", lastmod: gem.date)
  end

  add gems_path, changefreq: "daily"
  add docs_path, changefreq: "weekly"
  add community_path, changefreq: "weekly"
end
