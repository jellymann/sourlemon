class Post < ApplicationRecord
  before_save { |post| post.slug ||= post.title.parameterize          }
  before_save { |post| post.body_html = post.generate_body_html       }
  before_save { |post| post.summary_html = post.generate_summary_html }

  validates :body, presence: true
  validates :title, presence: true

  SUMMARY_HEIGHT = 252

  def slug_url
    @_slug_url ||= begin
      "/blog/#{created_at.strftime('%Y/%m/%d')}/#{slug}"
    end
  end

  def display_date
    created_at.strftime('%d %B %Y')
  end

  def short_display_date
    created_at.strftime("%e %b '%y")
  end

  def tags_csv
    tags.join(', ')
  end

  def tags_csv=(tags)
    tags = tags.split(',').map(&:strip)
  end

  def generate_body_html
    markdown.render(self.body)
  end

  def generate_summary_html
    Phantomjs.inline(summary_trim_script)
  end

  private

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
