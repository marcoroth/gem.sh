module MetaHelper
  def default_meta_tags
    {
      site: "gem.sh",
      title: "",
      reverse: true,
      separator: "-",
      description: "Beautiful documentation for any Ruby gem",
      keywords: "ruby, rails, rubyonrails, programming, documentation",
      canonical: request.original_url,
      noindex: !Rails.env.production?,
      og: {
        site_name: "gem.sh",
        # title: "gem.sh - Beautiful documentation for any Ruby gem",
        description: "Beautiful documentation for any Ruby gem",
        type: "website",
        url: request.original_url,
        image: image_url("social.png")
      },
      twitter: {
        card: "summary_large_image",
        creator: "@marcoroth_"
      }
    }
  end
end
