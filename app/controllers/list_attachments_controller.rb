class ListAttachmentsController < ApplicationController
  unloadable

  include SortHelper
  helper :sort

  include AttachmentsHelper
  helper :attachments

  include ListAttachmentsHelper
  helper :list_attachments

  def index
    sort_init 'created_on', 'desc'
    sort_update %w(filename container_id author_id created_on)

    @project = Project.find(params[:project_id])
    ids = Issue.where(:project_id => @project.id).select(:id).map(&:id)

    files = Attachment.where(container_type: 'Issue', container_id: ids)
    if params[:q] =~ /^#\d+$/
      files = files.where("container_id = :q", q: params[:q].delete('#'))
    else
      files = files.where("filename LIKE :q OR description LIKE :q", q: "%#{params[:q]}%")
    end

    if params[:time_period]
      files = files.time_period(params[:time_period], 'created_on')
    end

    if params[:created_on] && !params[:created_on].empty?
      # picked_date = params[:created_on]
      # next_date = DateTime.parse(params[:created_on]).next_day
      # files = files.where("created_on BETWEEN :picked AND :next ", picked: picked_date, next: next_date)

      files = files.where("DATE(created_on) = ? ", params[:created_on])

    end


    files = files.order(sort_clause)

    @count = files.count
    @pages, @attachments_in_project = paginate files, per_page: per_page_option



    respond_to do |format|
      format.html
      format.js{ params.merge!(format: 'html') }
    end

  end

end
