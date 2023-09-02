# frozen_string_literal: true

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

  add "/", changefreq: "weekly"
  add gems_path, changefreq: "daily"
  add docs_path, changefreq: "weekly"
  add community_path, changefreq: "weekly"

  Gem::Specification.all.each do |gem|
    add(gem_version_gem_path(gem.name, gem.version), changefreq: "weekly", lastmod: gem.date)

    spec = GemSpec.find(gem.name, gem.version)

    spec.classes.each do |klass|
      add(gem_version_class_path(spec.name, spec.version, klass.qualified_name), changefreq: "weekly", lastmod: gem.date)

      # spec.instance_methods.each do |method|
      #   add(gem_version_class_instance_method_path(spec.name, spec.version, klass.qualified_name, method.name), changefreq: "weekly", lastmod: gem.date)
      # end

      # spec.class_methods.each do |method|
      #   add(gem_version_class_class_method_path(spec.name, spec.version, klass.qualified_name, method.name), changefreq: "weekly", lastmod: gem.date)
      # end
    end

    spec.modules.each do |mod|
      add(gem_version_module_path(spec.name, spec.version, mod.qualified_name), changefreq: "weekly", lastmod: gem.date)

      # spec.instance_methods.each do |method|
      #   add(gem_version_module_instance_method_path(spec.name, spec.version, mod.qualified_name, method.name), changefreq: "weekly", lastmod: gem.date)
      # end

      # spec.class_methods.each do |method|
      #   add(gem_version_module_class_method_path(spec.name, spec.version, mod.qualified_name, method.name), changefreq: "weekly", lastmod: gem.date)
      # end
    end

    spec.instance_methods.each do |method|
      add(gem_version_instance_method_path(spec.name, spec.version, method.name), changefreq: "weekly", lastmod: gem.date)
    end

    spec.class_methods.each do |method|
      add(gem_version_class_method_path(spec.name, spec.version, method.name), changefreq: "weekly", lastmod: gem.date)
    end
  end
end
