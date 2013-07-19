# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

resources :projects do 
  resources :list_attachments, :only => :index
end

# get 'projects/:project_id/attachments' => 'list_attachments#index'
