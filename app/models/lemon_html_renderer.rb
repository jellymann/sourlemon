class LemonHTMLRenderer < Redcarpet::Render::HTML
  def block_code(code, language)
    "<textarea class=\"code-mirror\" data-mode=\"#{language}\">#{code}</textarea>"
  end
end
