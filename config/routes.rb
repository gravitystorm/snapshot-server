SnapshotServer::Application.routes.draw do

  resources :project do
    get 'tagged_nodes', :on => :member
    get 'tagged_ways', :on => :member
    get 'tagged_relations', :on => :member
  end

  match 'api/way/:id/status' => 'way#status', :via => :post
  match 'api/node/:id/status' => 'node#status', :via => :post
  match 'api/map' => 'api#map'
  match 'api/node/:id' => 'node#read'

  root :to => "site#index"

end
