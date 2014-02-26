Refinery::Core::Engine.routes.draw do

  # Frontend routes
  namespace :members, :path => '' do
    get 'perfil/:slug' => 'members#show', :as => 'member'
  end

  # Admin routes
  namespace :members, :path => '' do
    namespace :admin, :path => Refinery::Core.backend_route do
      resources :members, :except => :show do
        collection do
          post :update_positions
        end
      end
    end
  end

end
