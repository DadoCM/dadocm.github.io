require "json"
require "pathname"

destination = Pathname.new(ARGV.fetch(0))
html_files = Dir.glob(destination.join("**", "*.html").to_s)
unless html_files == [destination.join("index.html").to_s]
  abort "Portable builds currently support only a single root index.html. Found: #{html_files.join(", ")}"
end

html_path = destination.join("index.html")
html = html_path.read
html.gsub!(/(\b(?:href|src)=["'])\/(?!\/)/, '\1')
html_path.write(html)

js_path = destination.join("assets", "js", "just-the-docs.js")
js = js_path.read
["/assets/js/search-data.json", "/assets/css/just-the-docs-"].each do |url|
  quoted_url = "'#{url}'"
  abort "Expected theme URL not found: #{url}" unless js.include?(quoted_url)

  js.gsub!(quoted_url, "'#{url.delete_prefix("/")}'")
end
js_path.write(js)

search_path = destination.join("assets", "js", "search-data.json")
search_data = JSON.parse(search_path.read)
search_data.each_value do |entry|
  %w[url relUrl].each do |key|
    value = entry.fetch(key)
    entry[key] = value.sub(%r{\A/(?!/)}, "")
  end
end
search_path.write(JSON.generate(search_data))
