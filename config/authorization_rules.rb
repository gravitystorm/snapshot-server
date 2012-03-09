authorization do
  role :admin do
    includes :guest
    has_permission_on :projects, :to => :manage
  end

  role :guest do
    has_permission_on :devise_sessions, :devise_registrations, :devise_confirmations,
                      :devise_invitations, :devise_passwords, :to => :manage
    has_permission_on :site, :to => :index
    has_permission_on :projects, :to => [:view, :all_snippets, :tagged_nodes, :tagged_ways, :tagged_relations]
    has_permission_on :api_maps, :to => :view
    has_permission_on :api_node, :to => [:view, :status]
    has_permission_on :api_way, :to => [:view, :status]
  end
end

privileges do
  privilege :manage do
    includes :view, :new, :create, :edit, :update, :destroy
  end

  privilege :view do
    includes :index, :show
  end
end
