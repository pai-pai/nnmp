Nnmp::Application.routes.draw do
    root :to => "candidates#index"

    resources :users, :only => [ :show ]
    resources :sessions, :only => [ :new, :create, :destroy ]
    resources :candidates do
        resources :votes
    end
    resources :votes, :only => [ :index, :new, :create, :update, :destroy, :get_to_edut ]

    get "votes/get_to_edit"

    match "login" => "sessions#new"
    match "logout" => "sessions#destroy", :via => :delete

    namespace :dashboard do
        resources :users
        resources :areas
        resources :orgs
        resources :units
        resources :nominations, :only => [ :index, :new, :create, :edit, :update, :destroy, :get_to_edut ]
        resources :candidates, :only => [ :index, :edit, :update, :destroy, :move_votes ]

        get "nominations/get_to_edit"
        get "candidates/move_votes"

        match "add-user" => "users#new", :as => "add_user"

        match "/" => "pages#home", :as => "home"
        match "orgs-stat" => "pages#orgs_stat", :as => "orgs_stat"
    end
end
