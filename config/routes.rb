Nnmp::Application.routes.draw do
    resources :users, :only => [ :show ]
    resources :sessions, :only => [ :new, :create, :destroy ]

    match "login" => "sessions#new"
    match "logout" => "sessions#destroy", :via => :delete

    namespace :dashboard do
        resources :users
        resources :areas
        resources :orgs
        resources :units

        match "add-user" => "users#new", :as => "add_user"

        match "/" => "pages#home", :as => "home"
    end
end
