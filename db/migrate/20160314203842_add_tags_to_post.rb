class AddTagsToPost < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :tags, :string, array: true, default: []
  end
end
