class ListsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_list, only: [ :show, :edit, :update, :destroy ]

  def index
    set_lists
    @list = current_user.lists.new
  end

  def show
    @tasks = @list.tasks.active.order(:position)
    @task = current_user.tasks.new(list: @list)
  end

  def create
    @list = current_user.lists.new(list_params.merge(position: next_position))
    if @list.save
      @lists = current_user.lists.order(:position)
      respond_to do |f|
        f.turbo_stream
        f.html { redirect_to list_path, notice: "List created." }
      end
    else
      render :index, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @list.update(list_params)
      @lists = current_user.lists.order(:position)
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
    @lists = current_user.lists.order(:position)
    respond_to do |f|
      f.turbo_stream
      f.html { redirect_to lists_path, notice: "List deleted." }
    end
  end

  def reorder
    # expects params[:ids] = [list_id_new_order]
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

  def set_lists
    @lists = current_user.lists.order(:position)
  end

  def list_params
    params.require(:list).permit(:name, :color)
  end

  def next_position
    (current_user.lists.maximum(:position) || -1) + 1
  end
end
