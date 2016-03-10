Rails.application.routes.draw do
  root to: redirect('/posts')

  devise_for :users
  resources :posts, except: [:show]
  get '/posts/:year/:month/:slug', to: 'posts#show'
end
