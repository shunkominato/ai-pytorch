Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'test/index'
      get 'todos' => 'todos#index'
      post 'todos' => 'todos#create'
      get 'todo_statuses' => 'todo_statuses#index'

      mount_devise_token_auth_for 'User', at: 'auth'


      namespace :auth do
        resources :sessions, only: %i[index]
      end
    end
  end
  # devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
