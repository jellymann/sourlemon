class Post < ApplicationRecord
  before_save { |post| post.slug ||= post.title.parameterize }
  before_save { |post| post.body_html = post.generate_body_html if post.body_changed? }
  before_save { |post| post.summary_html = post.generate_summary_html if post.body_changed? || post.title_changed? }
  before_save { |post| post.published_at ||= Time.zone.now if published? }

  validates :body, presence: true
  validates :title, presence: true
  validates :published_at, presence: true, if: :published?

  scope :published,   -> { where(published: true) }
  scope :unpublished, -> { where(published: false).or(Post.where(published: nil)) }

  SUMMARY_HEIGHT = 252

  def slug_path
    "/blog/#{published_or_created_at.strftime('%Y/%m/%d')}/#{slug}"
  end

  def display_date
    published_or_created_at.strftime('%e %B %Y')
  end

  def short_display_date
    published_or_created_at.strftime("%e %b '%y")
  end

  def listing_display_date
    published_or_created_at.strftime '%e %b'
  end

  def tags_csv
    tags.join(', ')
  end

  def tags_csv=(value)
    self.tags = value.split(',').map(&:strip)
  end

  def generate_body_html
    markdown.render(self.body)
  end

  def generate_summary_html
    PostSummaryTrimmer.new(self).perform
  end

  def self.from_jekyll(markdown)
    markdown =~ /^(---\s*\n.*?\n?)^(---\s*$\n?)/m
    metadata = YAML.load($1) if $1
    markdown = $' or markdown
    tags = metadata["categories"] || metadata["category"] || []
    tags = [tags] if tags.is_a? String

    markdown.gsub!(
      /\{\% post_url (\d\d\d\d)-(\d\d)-(\d\d)-([^\s]+) \%\}/,
      '/blog/\1/\2/\3/\4'
    )

    markdown.gsub!(/\{\% img \w+ \/images\/([^\s]+) \%\}/) do
      alt_text = $1.underscore.humanize.split('.').first.split(' ').map(&:capitalize).join(' ')
      "![#{alt_text}](#{Sourlemon::Application.secrets.images_url}/#{$1})"
    end

    Post.new title: metadata["title"],
             body: markdown,
             tags: tags,
             published_at: metadata["date"]
  end

  private

  def published_or_created_at
    published_at || created_at
  end

  def markdown
    @_markdown ||= Redcarpet::Markdown.new(LemonHTMLRenderer, fenced_code_blocks: true)
  end
end
