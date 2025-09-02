class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    task = current_user.tasks.find(params[:task_id])
    attachment = task.files.find(params[:attachment_id])
    attachment.purge_later
    respond_to do |f|
      f.turbo_stream { render turbo_stream: turbo_stream.replace(dom_id(task), partial: "tasks/row", locals: { task: }) }
      f.html { redirect_to list_path(task.list), notice: "Attachment removed." }
    end
  end
end
