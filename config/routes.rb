Nnmp::Application.routes.draw do
    resources :users, :only => [ :show ]
    resources :sessions, :only => [ :new, :create, :destroy ]

    match "login" => "sessions#new"
    match "logout" => "sessions#destroy", :via => :delete

    namespace :dashboard do
        resources :users
    end
end
