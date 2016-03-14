require 'rouge/plugins/redcarpet'

class LemonHTMLRenderer < Redcarpet::Render::HTML
  include Rouge::Plugins::Redcarpet
end
