Rails.application.routes.draw do
  root 'home#index'

  get '/account', to: 'user#show'
  get '/register', to: 'user#new'
  post '/register', to: 'user#create'

  get '/login', to: 'session_token#new'
  delete '/logout', to: 'session_token#destroy'
  post '/login', to: 'session_token#create'
end
