class SavedViewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_list

  def create
    q = params.permit(:q, :due, :priority, :status, :tag, :sort).to_h.compact_blank
    view = current_user.saved_views.new(list: @list, name: params.require(:name), query: q)
    if view.save
      redirect_to list_path(@list, q), notice: "View saved."
    else
      redirect_to @list, alert: view.errors.full_messages.to_sentence
    end
  end

  def destroy
    current_user.saved_views.find_by!(list: @list, id: params[:id]).destroy
    redirect_to @list, notice: "View deleted."
  end

  private
  def set_style
    @list = current_user.lists.find(params[:list_id])
  end
end
