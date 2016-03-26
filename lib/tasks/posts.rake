namespace :posts do
  desc "Generate HTML from Post Markdown and save it in the database"
  task cache_html: :environment do
    count = Post.count
    puts "0/#{count} (0%)"
    Post.all.each_with_index do |post, i|
      post.body_html = post.generate_body_html
      post.summary_html = post.generate_summary_html
      post.save!
      puts "#{i+1}/#{count} (#{(((i+1).to_f/count.to_f)*100.0).to_i}%)"
    end
  end
end
