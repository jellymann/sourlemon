class Post < ApplicationRecord
  before_save { |post| post.slug ||= post.title.parameterize }

  validates :body, presence: true
  validates :title, presence: true

  def body_html
    @_body_html ||= markdown.render(self.body).html_safe
  end

  def slug_url
    @_slug_url ||= begin
      "/blog/#{created_at.strftime('%Y/%m/%d')}/#{slug}"
    end
  end

  private

  def markdown
    @_markdown ||= Redcarpet::Markdown.new(LemonHTMLRenderer)
  end
end
