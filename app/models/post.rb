class Post < ApplicationRecord
  scope :published, -> { where(published: true).order(published_at: :desc) }
end
