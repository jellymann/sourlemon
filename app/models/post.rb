class Post < ApplicationRecord
  def body_html
    markdown.render(self.body).html_safe
  end

  private

  def markdown
    @_markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML)
  end
end
