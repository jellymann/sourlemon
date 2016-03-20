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

  def tags_csv
    tags.join(', ')
  end

  def tags_csv=(tags)
    tags = tags.split(',').map(&:strip)
  end

  private

  def markdown
    @_markdown ||= Redcarpet::Markdown.new(LemonHTMLRenderer, fenced_code_blocks: true)
  end
end
