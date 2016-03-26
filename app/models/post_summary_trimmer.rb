class PostSummaryTrimmer
  ERROR_STRING = "*** SOMETHING WENT WRONG ***";

  class JSError < StandardError; end

  def initialize post
    @post = post
  end

  def perform(phantomjs = Phantomjs)
    phantomjs.inline(summary_trim_script).strip.tap do |result|
      handle_error(result)
    end
  end

  private

  def summary_markdown
    @_markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML, fenced_code_blocks: true)
  end

  def post_body_html
    summary_markdown.render(@post.body)
  end

  def post_wrapper_html
    Slim::Template.new(File.expand_path('../post_summary_trimmer_snippets/post_wrapper.slim', __FILE__)).render(self)
  end

  def summary_trim_script
    b = binding
    erb = ERB.new(File.read(File.expand_path('../post_summary_trimmer_snippets/summary_trim_script.js.erb', __FILE__)))
    erb.result(b)
  end

  def handle_error(result)
    raise JSError.new(result.split(ERROR_STRING)[1]) if result.include?(ERROR_STRING)
  end
end
