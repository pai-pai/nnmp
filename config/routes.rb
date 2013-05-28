Nnmp::Application.routes.draw do
    root :to => "candidates#index"

    resources :users, :only => [ :show ]
    resources :sessions, :only => [ :new, :create, :destroy ]
    resources :candidates do
        resources :votes
    end
    resources :votes

    get "votes/get_to_edit"
    match "get-vote-to-edit" => "votes#get_to_edit"

    get "candidates/get_io"
    match "get-io" => "candidates#get_io"

    match "login" => "sessions#new"
    match "logout" => "sessions#destroy", :via => :delete

    namespace :dashboard do
        resources :users
        resources :areas
        resources :orgs
        resources :units
        resources :nominations
        resources :candidates

        get "nominations/get_to_edit"
        match "get-nomination-to-edit" => "nominations#get_to_edit"
        get "candidates/move_votes"
        match "move-votes" => "candidates#move_votes"
        get "candidates/get_to_edit"
        match "get-candidate-to-edit" => "candidates#get_to_edit"
        get "pages/get_comment"
        match "get-votes-comment" => "pages#get_comment"

        match "add-user" => "users#new", :as => "add_user"

        match "/" => "pages#home", :as => "home"
        match "orgs-stat" => "pages#orgs_stat", :as => "orgs_stat"
    end
end
