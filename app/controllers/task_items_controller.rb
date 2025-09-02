class TaskItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task

  def create
    item = @task.task_items.create!(title: params.require(:task_item)[:title], position: next_position)
    render turbo_stream: turbo_stream.replace(dom_id(@task), partial: "tasks/row", locals: { task: @task })
  end

  def update
    item = @task.task_items.find(params[:id])
    attrs = params.require(:task_item).permit(:title, :completed_at)
    if params[:completed] == "toggle"
      item.update!(completed_at: (item.completed_at ? nil : Time.current))
    else
      item.update!(attrs)
    end
    render turbo_stream: turbo_stream.replace(dom_id(@task), partial: "tasks/row", locals: { task: @task })
  end

  def destroy
    @task.task_items.find(params[:id]).destroy
    render turbo_stream: turbo_stream.replace(dom_id(@task), partial: "tasks/row", locals: { task: @task })
  end

  private
  def set_task
    @task = current_user.tasks.find(params[:task_id])
  end
  def next_position
    (@task.task_items.maximum(:position) || -1) + 1
  end
end
