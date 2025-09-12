class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_list
  before_action :set_task, only: [ :edit, :update, :destroy, :toggle_status ]

  def create
    @task = current_user.tasks.new(task_params.except(:recurrence).merge(list: @list, position: next_position))
    if @task.save
      handle_recurrence(@task, task_params[:recurrence])
      respond_to do |f|
        f.turbo_stream
        f.html { redirect_to @list, notice: "Task added." }
      end
    else
      prepare_list_show_ivars
      render "lists/show", status: :unprocessable_entity
    end
  end


  def edit; end

  def update
    if @task.update(task_params.except(:recurrence))
      handle_recurrence(@task, task_params[:recurrence])
      respond_to do |f|
        f.turbo_stream
        f.html { redirect_to @list, notice: "Task updated." }
      end
    else
      prepare_list_show_ivars
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

  def handle_recurrence(task, recurrence_params)
    return if recurrence_params.blank? || recurrence_params[:type].blank?
    schedule = RecurrenceService.build_schedule(task: task, params: recurrence_params, time_zone: current_user.time_zone || "America/Toronto")
    RecurrenceService.set_recurrence!(task: task, schedule:, time_zone: current_user.time_zone || "America/Toronto")
  end

  private

  def prepare_list_show_ivars
    @tasks = TasksQuery
              .new(@list.tasks.active)
              .call(params.slice(:q, :due, :priority, :status, :tag, :sort))
    @available_tags = @list.tasks.tag_counts_on(:tags).map(&:name)
    @saved_views    = current_user.saved_views.where(list: @list).order(:name)
    @task           = @task || current_user.tasks.new(list: @list)
  end

  def set_list
    @list = current_user.lists.find(params[:list_id])
  end
  def set_task
    @task = @list.tasks.find(params[:id])
  end
  def task_params
    p = params.require(:task).permit(:title, :notes, :due_at, :priority, :status, :tag_list, files: [],
                                   recurrence: [ :type, :interval, :day, days: [] ])
    # Normalize tag_list (string -> array) because our create form used a text field
    if p[:tag_list].is_a?(String)
      p[:tag_list] = p[:tag_list].split(",").map(&:strip)
    end
    p
  end
  def next_position
    (@list.tasks.maximum(:position) || -1) + 1
  end
end
