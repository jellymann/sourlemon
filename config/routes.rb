Rails.application.routes.draw do
  root to: redirect('/posts')

  devise_for :users
  resources :posts
end
