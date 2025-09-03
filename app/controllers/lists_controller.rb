class ListsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_list, only: [ :show, :edit, :update, :destroy ]

  def index
    @lists = current_user.lists.order(:position)
    @list  = current_user.lists.new
  end

  def show
    @tasks = @list.tasks.active.order(:position)
    @task  = current_user.tasks.new(list: @list)
  end

  def create
    @list = current_user.lists.new(list_params.merge(position: next_position))
    if @list.save
      respond_to do |f|
        f.turbo_stream
        f.html { redirect_to lists_path, notice: "List created." }
      end
    else
      @lists = current_user.lists.order(:position)
      render :index, status: :unprocessable_entity
    end
  end

  def edit
    # Renders edit.html.erb; now explicitly wrapped in the correct turbo_frame_tag
  end

  def update
    if @list.update(list_params)
      respond_to do |f|
        f.turbo_stream
        f.html { redirect_to lists_path, notice: "List updated." }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @list.destroy
    respond_to do |f|
      f.turbo_stream
      f.html { redirect_to lists_path, notice: "List deleted." }
    end
  end

  def reorder
    ActiveRecord::Base.transaction do
      params[:ids].each_with_index do |id, idx|
        current_user.lists.where(id: id).update_all(position: idx)
      end
    end
    head :ok
  end

  private

  def set_list
    @list = current_user.lists.find(params[:id])
  end

  def list_params
    params.require(:list).permit(:name, :color)
  end

  def next_position
    (current_user.lists.maximum(:position) || -1) + 1
  end
end
