class RecurrenceService
  # Build an IceCube::Schedule from a hash like:
  # { "type"=>"daily", "interval"=>"1" }
  # { "type"=>"weekly", "interval"=>"1", "days"=>["monday","wednesday"] }
  # { "type"=>"monthly", "interval"=>"1", "day"=>"15" } # simple monthly by day-of-month
  def self.build_schedule(task:, params:, time_zone: "America/Toronto")
    start_time = task.due_at || Time.current
    schedule = IceCube::Schedule.new(start_time.in_time_zone(time_zone))
    interval = params["interval"].to_i.nonzero? || 1

    case params["type"]
    when "daily"
      schedule.add_recurrence_rule IceCube::Rule.daily(interval)
    when "weekly"
      days = Array(params["days"]).map { |d| d.to_sym }
      rule = IceCube::Rule.weekly(interval)
      rule = rule.day(*days) if days.any?
      schedule.add_recurrence_rule rule
    when "monthly"
      day = params["day"].to_i
      if day > 0
        schedule.add_recurrence_rule IceCube::Rule.monthly(interval).day_of_month(day)
      else
        schedule.add_recurrence_rule IceCube::Rule.monthly(interval)
      end
    else
      raise ArgumentError, "Unknown recurrence type"
    end

    schedule
  end

  # Persist or update RecurrenceRule on a task
  def self.set_recurrence!(task:, schedule:, time_zone: "America/Toronto")
    rr = task.recurrence_rule || task.build_recurrence_rule(time_zone:)
    rr.schedule = schedule
    rr.next_occurrence_at = next_occurrence_from(schedule, after: task.due_at || Time.current)
    rr.save!
    rr
  end

  def self.next_occurrence_from(schedule, after:)
    schedule.next_occurrence(after)&.to_time
  end

  # When a user completes a recurring task, create the next instance.
  # Strategy: duplicate core fields, carry tags and attachments? (we carry tags; skip files by default).
  def self.materialize_next!(task)
    rr = task.recurrence_rule or return
    current_due = task.due_at || Time.current
    schedule = rr.schedule
    next_time = next_occurrence_from(schedule, after: current_due)

    return unless next_time

    new_task = Task.create!(
      user: task.user,
      list: task.list,
      title: task.title,
      notes: task.notes,
      due_at: next_time,
      priority: task.priority,
      status: :todo,
      position: ((task.list.tasks.maximum(:position) || -1) + 1),
      tag_list: task.tag_list
    )

    # Update tracker for following instance
    rr.update!(next_occurrence_at: next_occurrence_from(schedule, after: next_time))
    new_task
  end
end
