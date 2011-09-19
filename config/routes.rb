CouchbaseTinyurl::Application.routes.draw do
  resources :links do
    get :short, :on => :member
    get :my, :on => :collection
    get :recent, :on => :collection
    get :popular, :on => :collection
  end
  root :to => 'links#my'
  match "/:id", :to => 'links#short', :as => :short
end
