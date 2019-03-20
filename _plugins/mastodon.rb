# frozen_string_literal: true
class Mastodon < Liquid::Tag
  def initialize(tag_name, input, tokens)
    super
    @src = input.strip
  end

  def render(context)
    @scriptsrc = @src.gsub(%r{^https://([^/]+).*}, 'https://\1/embed.js')
    %(<iframe src="#{@src}/embed" class="mastodon-embed"
    style="max-width: 100%; border: 0" width="400"></iframe><script
    src="#{@scriptsrc}" async="async"></script>)
  end
end

Liquid::Template.register_tag('mastodon', Mastodon)
