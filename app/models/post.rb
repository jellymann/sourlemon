class Post < ApplicationRecord
  before_save { |post| post.slug ||= post.title.parameterize }

  validates :body, presence: true
  validates :title, presence: true

  def body_html
    @_body_html ||= markdown.render(self.body).html_safe
  end

  def slug_url
    @_slug_url ||= begin
      year = created_at.year
      month = created_at.month
      "/posts/#{year}/#{month}/#{slug}"
    end
  end

  private

  def markdown
    @_markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML)
  end
end
