class ListAttachmentsController < ApplicationController
  unloadable

  include AttachmentsHelper
  helper :attachments

  before_filter :find_attachments_in_project

  def index
  end

  def search
    @attachments_in_project = @attachments_in_project.where("filename LIKE :q OR description LIKE :q", q: '%'+params[:q]+'%')
    render :layout => false
  end

  private

  def find_attachments_in_project
    @project = Project.find(params[:project_id])
    ids = Issue.where(:project_id => @project.id).select(:id).map(&:id)
    @attachments_in_project = Attachment.where(container_type: 'Issue', container_id: ids)
  end
    
    
end
