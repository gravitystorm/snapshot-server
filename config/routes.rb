SnapshotServer::Application.routes.draw do

  resources :project

  namespace :browse do
    get 'tagged_nodes'
    get 'tagged_ways'
    get 'tagged_relations'
  end

  match 'api/way/:id/status' => 'way#status', :via => :post
  match 'api/node/:id/status' => 'node#status', :via => :post
  match 'api/map' => 'api#map'
  match 'api/node/:id' => 'node#read'

  root :to => "site#index"

end
