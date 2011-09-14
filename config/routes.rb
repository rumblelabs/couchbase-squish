CouchbaseTinyurl::Application.routes.draw do
  resources :links do
    get :view, :on => :member
  end
  root :to => 'links#index'
  match "/:id", :to => 'links#view', :as => :short
end
