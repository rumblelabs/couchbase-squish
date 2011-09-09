CouchbaseTinyurl::Application.routes.draw do
  resources :links
  root :to => 'links#index'
  match "/:id", :to => 'links#show', :as => :short
end
