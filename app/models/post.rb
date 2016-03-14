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

  def display_date
    created_at.strftime('%d %B %Y')
  end

  def metadata
    {
      title: title,
      date: display_date,
      url: slug_url,
      tags: tags
    }
  end

  private

  def markdown
    @_markdown ||= Redcarpet::Markdown.new(LemonHTMLRenderer, fenced_code_blocks: true)
  end
end
