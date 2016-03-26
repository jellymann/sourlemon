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
    # puts "\n" + "/"*50
    # puts summary_trim_script
    # puts "\n" + "/"*50
    phantomjs.inline(summary_trim_script).strip
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

  def phantomjs
    @_phantomjs ||= Phantomjs.new()
  end

  def html_for_summary
    summary_markdown.render(self.body)
  end

  def html_wrapper_for_summary_trim
    """
    <div class=\"content\" id=\"content\" style=\"opacity: 1;\">
      <div class=\"post post-summary\" id=\"postContainer\">
        <div class=\"pre-body\">
          -
        </div>
        <div class=\"body\" id=\"postBody\">
          <h1>#{title}</h1>
        </div>
      </div>
    </div>
    """
  end

  def js_try_catch
    """
    try {
      #{yield}
    } catch (error) {
      console.log('*** SOMETHING WENT WRONG ***');
      console.log(error.stack);
      alert('DONE');
    }
    """
  end

  def phantom_page_evaluate
    """
    try {
      var page = require('webpage').create();
      page.viewportSize = { width: 1920, height: 1080 };
      page.onConsoleMessage = console.log.bind(console);
      page.onAlert = function(msg) {
        if (msg === 'DONE') phantom.exit();
      };
      page.open('about:blank', function(status) {
        page.evaluate(function() {
          #{ js_try_catch { yield } }
        });
      });
    } catch (error) {
      console.log('*** SOMETHING WENT WRONG ***');
      console.log(error.stack);
      phantom.exit();
    }
    """
  end

  def summary_trim_script
    phantom_page_evaluate do
      """
      document.head.innerHTML += '<style>' +
        #{::Sprockets::Railtie.build_environment(Rails.application)["application-inline.css"].to_s.chomp.to_json} +
        #{::Sprockets::Railtie.build_environment(Rails.application)["posts-index-inline.css"].to_s.chomp.to_json} +
        #{::Sprockets::Railtie.build_environment(Rails.application)["application.css"].to_s.chomp.to_json} +
      '</style>';
      document.getElementsByTagName('html')[0].classList.add('css-loaded');
      #{::Sprockets::Railtie.build_environment(Rails.application)["webfontloader/webfontloader.js"].to_s}
      WebFont.load({
        google: { families: [
          'Roboto:400,300,300italic,400italic,500,500italic,700,700italic',
          'Roboto+Mono:400,700'
        ] },
        active: function() {
          document.body.innerHTML += #{html_wrapper_for_summary_trim.to_json};

          var wrapper = document.getElementById('postBody');
          var postContainer = document.getElementById('postContainer');
          var maxHeight = document.defaultView.getComputedStyle(postContainer, null).getPropertyValue('max-height');
          maxHeight = parseInt(maxHeight.replace(/(\\d+)px/, '$&'), 10);

          var fullBody = document.createElement('div');
          fullBody.innerHTML = #{html_for_summary.to_json};

          var lastHeight = 0;
          while (fullBody.children.length > 0) {
            wrapper.appendChild(fullBody.children[0]);
            if (postContainer.clientHeight === lastHeight) {
              wrapper.children[wrapper.children.length - 1].remove();
              break;
            }
            if (postContainer.clientHeight >= maxHeight) break;
            lastHeight = postContainer.clientHeight;
          }
          wrapper.getElementsByTagName('h1')[0].remove();
          console.log(wrapper.innerHTML);
          alert('DONE');
        }
      });
      """
    end
  end
end
