Fixelpuckers::Application.routes.draw do
  
  resources :forum_groups, :categories

  resources :forums do
    resources :topics
  end
  
  resources :topics do
    resources :posts
  end

  match "confirm_user", :to => "users#confirm"
  
  resources :users do
    resources :comments
  end

  match "moderated_submissions", :to => "submissions#moderated"
  
  resources :submissions do
    resources :reviews
  end
  
  match "submissions/:id/download" => "submissions#download", :as => :download_submission
  match "submissions/:id/trash" => "submissions#trash", :as => :trash_submission
  match "submissions/:id/untrash" => "submissions#untrash", :as => :untrash_submission
  match "submissions/:id/moderate" => "submissions#moderate", :as => :moderate_submission
  match "submissions/:id/unmoderate" => "submissions#unmoderate", :as => :unmoderate_submission
  match "submissions/:id/feature" => "submissions#feature", :as => :feature_submission
  match "submissions/:id/unfeature" => "submissions#unfeature", :as => :unfeature_submission

  resources :static_pages do
    resources :comments
  end

  resources :comments, :only => [:destroy]
  resources :reviews, :only => [:destroy]
  resources :featured, :controller => "features"
  
  resources :announcements do
    resources :comments
  end

  root :to => "pages#root"
  match "browse", :to => "pages#browse"
  match "login", :to => "sessions#new"
  match "logout", :to => "sessions#destroy"
  match "register", :to => "users#new"

  match ":controller/:action/(:id(.:format))"
end
