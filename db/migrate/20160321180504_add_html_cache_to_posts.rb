class AddHtmlCacheToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :body_html, :text
    add_column :posts, :summary_html, :text
  end
end
