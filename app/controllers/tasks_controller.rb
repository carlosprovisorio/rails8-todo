class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_list
  before_action :set_task, only: [ :edit, :update, :destroy, :toggle_status ]

  def create
    @task = current_user.tasks.new(task_params.merge(list: @list, position: next_position))
    if @task.save
      respond_to do |f|
        f.turbo_stream
        f.html { redirect_to @list, notice: "Task added." }
      end
    else
      render "lists/show", status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @task.update(task_params)
      respond_to do |f|
        f.turbo_stream
        f.html { redirect_to @list, notice: "Task updated." }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    respond_to do |f|
      f.turbo_stream
      f.html { redirect_to @list, notice: "Task deleted." }
    end
  end

  def toggle_status
    @task.status_done? ? @task.status_todo! : @task.status_done!
    respond_to(&:turbo_stream)
  end

  def reorder
    ActiveRecord::Base.transaction do
      params[:ids].each_with_index do |id, idx|
        current_user.tasks.where(id: id, list_id: params[:list_id]).update_all(position: idx)
      end
    end
    head :ok
  end

  private
  def set_list
    @list = current_user.lists.find(params[:list_id])
  end
  def set_task
    @task = @list.tasks.find(params[:id])
  end
  def task_params
    params.require(:task).permit(:title, :notes, :due_at, :priority, :status, tag_list: [], files: [])
  end
  def next_position
    (@list.tasks.maximum(:position) || -1) + 1
  end
end
