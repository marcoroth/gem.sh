module ApplicationHelper
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
        title: "gem.sh",
        description: "Beautiful documentation for any Ruby gem",
        type: "website",
        url: request.original_url,
        image: image_url("social.png")
      }
    }
  end

  def to_short_sentence(array, limit: 3)
    if array.length > limit
      remaining = array.length - limit

      "#{array.first(3).join(", ")} and #{remaining} more"
    else
      array.to_sentence
    end
  end
end
