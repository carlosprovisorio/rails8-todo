class TasksQuery
  attr_reader :relation

  def initialize(relation = Task.all)
    @relation = relation.includes(:list, :tags).references(:tags)
  end

  # params: { q:, due:, priority:, status:, tag:, sort: }
  def call(params = {})
    r = relation
    r = r.merge(Task.search_text(params[:q])) if params[:q].present?

    case params[:due]
    when "overdue"  then r = r.overdue
    when "today"    then r = r.due_today
    when "week"
      r = r.where(due_at: Time.current.beginning_of_week..Time.current.end_of_week, archived_at: nil)
    when "none"     then r = r.where(due_at: nil, archived_at: nil)
    end

    r = r.where(priority: Task.priorities[params[:priority]]) if params[:priority].present?
    r = r.where(status:   Task.statuses[params[:status]])     if params[:status].present?
    r = r.tagged_with(params[:tag], any: true)                if params[:tag].present?

    r = apply_sort(r, params[:sort])
    r
  end

  private

  def apply_sort(r, key)
    case key
    when "due_asc"     then r.order(Arel.sql("due_at NULLS LAST"))
    when "due_desc"    then r.order(Arel.sql("due_at DESC NULLS LAST"))
    when "priority"    then r.order(priority: :desc, created_at: :desc)
    when "created_desc" then r.order(created_at: :desc)
    when "created_asc"  then r.order(created_at: :asc)
    when "manual"      then r.order(:position)
    else r.order(:position)
    end
  end
end
