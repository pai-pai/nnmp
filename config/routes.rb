Nnmp::Application.routes.draw do
    root :to => "votes#index"

    resources :users, :only => [ :show ]
    resources :sessions, :only => [ :new, :create, :destroy ]
    resources :candidates do
        resources :votes
    end
    resources :votes

    match "login" => "sessions#new"
    match "logout" => "sessions#destroy", :via => :delete

    namespace :dashboard do
        resources :users
        resources :areas
        resources :orgs
        resources :units
        resources :nominations

        match "add-user" => "users#new", :as => "add_user"

        match "/" => "pages#home", :as => "home"
        match "orgs-stat" => "pages#orgs_stat", :as => "orgs_stat"
    end
end
