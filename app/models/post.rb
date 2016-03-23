class Post < ApplicationRecord
  before_save { |post| post.slug ||= post.title.parameterize             }
  before_save { |post| post.body_html = post.generate_body_html          }
  before_save { |post| post.summary_html = post.generate_summary_html    }
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
    Phantomjs.inline(summary_trim_script)
  end

  private

  def published_or_created_at
    published_at || created_at
  end

  def markdown
    @_markdown ||= Redcarpet::Markdown.new(LemonHTMLRenderer, fenced_code_blocks: true)
  end

  def summary_markdown
    @_markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML, fenced_code_blocks: true)
  end

  def html_for_summary
    summary_markdown.render(self.body).
      gsub("\\", "\\\\").
      gsub("\n", "\\n").
      gsub("'", "\\'")
  end

  def summary_trim_script
    """
      var summary = document.createElement('div');
      summary.innerHTML = '#{html_for_summary}';
      var newSummary = document.createElement('div');
      document.body.appendChild(newSummary);
      while (summary.children.length > 0) {
        newSummary.appendChild(summary.children[0]);
        if (newSummary.clientHeight > #{SUMMARY_HEIGHT}) break;
      }
      console.log(newSummary.innerHTML);
      phantom.exit();
    """
  end
end
