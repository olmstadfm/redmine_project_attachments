Redmine::Plugin.register :redmine_project_attachments do
  name 'Redmine Project Attachments plugin'
  author 'antonovgks'
  description 'Adds project tab with all files in project'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'

  permission :view_project_attachments,  :list_attachments => [:index]
  
  menu :project_menu,
       :list_attachments,
       {:controller => :list_attachments, :action => :index}, 
       :caption => :label_attachments_plural,
       :param => :project_id,
       :if => Proc.new{ |project| User.current.allowed_to?({:controller => :list_attachments, :action => :index}, project) }

end

Rails.configuration.to_prepare do

  require 'time_period_scope'

  [ 
   [Attachment, TimePeriodScope]
  ].each do |cl, patch|
    cl.send(:include, patch) unless cl.included_modules.include? patch
  end
end
