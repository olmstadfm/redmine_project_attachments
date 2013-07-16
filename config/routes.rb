# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

resources :list_attachments do
  collection do
        get :search
  end
end
