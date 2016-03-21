namespace :posts do
  desc "Generate HTML from Post Markdown and save it in the database"
  task cache_html: :environment do
    Post.all.each do |post|
      post.body_html = post.generate_body_html
      post.summary_html = post.generate_summary_html
      post.save!
    end
  end
end
