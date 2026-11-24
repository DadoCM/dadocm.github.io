require "jekyll"

config = Jekyll.configuration(
  "config" => "_config.yml",
  "destination" => "_portable_site"
)
config["exclude"] |= ["docs"]
Jekyll::Site.new(config).process
