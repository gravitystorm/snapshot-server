SnapshotServer::Application.routes.draw do

  devise_for :admins

  resources :projects do
    get 'tagged_nodes', :on => :member
    get 'tagged_ways', :on => :member
    get 'tagged_relations', :on => :member
    namespace :api do
      resource :map
      resources :way do
        post 'status'
      end
      resources :node do
        post 'status', :on => :member
      end
    end
  end

  root :to => "site#index"

end
