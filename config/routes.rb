ActionController::Routing::Routes.draw do |map|
  map.confirm_user "users/confirm", :controller => "users", :action => "confirm"
  map.resources :users

  map.moderated_submissions "submissions/moderated",      :controller => "submissions", :action => "moderated"
  map.resources :submissions do |submission|
    submission.resources :reviews
  end
  map.download_submission   "submissions/:id/download",   :controller => "submissions", :action => "download"
  map.trash_submission      "submissions/:id/trash",      :controller => "submissions", :action => "trash"
  map.untrash_submission    "submissions/:id/untrash",    :controller => "submissions", :action => "untrash"
  map.moderate_submission   "submissions/:id/moderate",   :controller => "submissions", :action => "moderate"
  map.unmoderate_submission "submissions/:id/unmoderate", :controller => "submissions", :action => "unmoderate"
  map.feature_submission    "submissions/:id/feature",    :controller => "submissions", :action => "feature"
  map.unfeature_submission  "submissions/:id/unfeature",  :controller => "submissions", :action => "unfeature"

  map.resources :categories
  map.resources :features, :as => :featured
  map.resources :announcements

  map.root                 :controller => "pages",     :action => "root"
  map.browse   "browse",   :controller => "pages",     :action => "browse"
  map.login    "login",    :controller => "sessions",  :action => "new"
  map.logout   "logout",   :controller => "sessions",  :action => "destroy"
  map.register "register", :controller => "users",     :action => "new"

  map.connect ":controller/:action/:id.:format"
  map.connect ":controller/:action/:id"
end
