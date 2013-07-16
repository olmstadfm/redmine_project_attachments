class ListAttachmentsController < ApplicationController
  unloadable

  helper :sort
  include SortHelper

  include AttachmentsHelper
  helper :attachments

  def index
    @project = Project.find(params[:project_id])
    issues = Issue.where(:project_id => @project.id)
    ids = issues.map(&:id)
    @attachments_in_project = Attachment.where( :container_type => 'Issue', :container_id => ids )
    @issues = @project.issues
  end

  def search
    @project = Project.find(params[:project_id])
    attachments_in_project_ids = @project.issues.map(&:attachment_ids).flatten
    @attachments_in_project = Attachment.
      where(id: attachments_in_project_ids).
#      where("filename LIKE ?", '%'+params[:q]+'%')
       where("filename LIKE :q OR description LIKE :q", q: '%'+params[:q]+'%')


    @issues = @attachments_in_project.map{|a| Issue.find(a.container_id)}
    render :layout => false
  end

end
