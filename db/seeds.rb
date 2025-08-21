require "faker"

puts "Wiping data..."
Reminder.delete_all
RecurrenceRule.delete_all
TaskItem.delete_all
Task.delete_all
List.delete_all
User.delete_all


puts "Creating user..."
user = User.create!(
  email: "demo@example.com",
  password: "password123",
  first_name: "Demo",
  last_name: "User",
  time_zone: "America/Toronto"
)

puts "Creating tasks..."

work = user.lists.create!(name: "Work", color: "#2b6cb0", position: 1)
home = user.lists.create!(name: "Home", color: "#38a169", position: 2)
ideas = user.lists.create!(name: "Ideas", color: "#d69e2e", position: 3)

puts "Creating tasks..."
lists = [ work, home, ideas ]
priorities = Task.priorities.keys
statuses = Task.statuses.keys

25.times do |i|
  list = lists.sample
  t = user.tasks.create!(
    list: list,
    title: Faker::Hacker.ingverb.titleize + " " + Faker::Hacker.noun.titleize,
    notes: Faker::Lorem.paragraph(sentence_count: 2),
    due_at: rand(0..1).zero? ? (Time.current + rand(-3..10).days) : nil,
    priority: priorities.sample,
    status: statuses.sample,
    position: i
  )
  # subtasks
  rand(0..3).times do |j|
    t.task_items.create!(title: "Subtask #{j + 1}", position: j)
  end
  # tags
  t.tag_list = %w[personal urgent backend quick refactor chores feature bug].sample(rand(1..3))
  t.save!

  # occasional reminder
  if t.due_at && rand(0..1).zero?
    t.reminders.create!(remind_at: t.due_at - 6.hours, channel: "email")
  end
end
