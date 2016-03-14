Rails.application.routes.draw do
  root to: 'posts#index'

  devise_for :users
  resources :posts, except: [:show, :index]
  get '/blog/:year/:month/:day/:slug', to: 'posts#show',
    year: /\d\d\d\d/,
    month: /\d\d/,
    dat: /\d\d/

  get '/blog/categories/:tag', to: 'categories#show'
  get '/blog/archives', to: 'archives#show'
end
