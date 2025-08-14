# README

# Rails 8 ToDo Application

A feature-rich ToDo application built with **Ruby 3.3**, **Rails 8**, **PostgreSQL**, **Bootstrap**, and **Hotwire** (Turbo + Stimulus).  
The app focuses on beautiful UI/UX, interactive task management, and clean Rails best practices — no scaffolds.

## Features (Planned)
- User accounts with built-in Rails authentication (`has_secure_password`)
- Task lists & projects
- Due dates, priorities, tags
- Recurring tasks & reminders
- Attachments with Active Storage
- Subtasks & progress tracking
- Full-text search, filters, sorting
- Dark mode & responsive design
- Background jobs with Sidekiq

## Tech Stack
- **Backend:** Ruby 3.3, Rails 8
- **Database:** PostgreSQL
- **Frontend:** Bootstrap 5, custom SCSS, Hotwire (Turbo & Stimulus)
- **JS Bundler:** esbuild via `jsbundling-rails`
- **Background Jobs:** Sidekiq, Redis
- **Search:** pg_search
- **Tags:** acts-as-taggable-on
- **Recurring Tasks:** ice_cube

## Development Setup

### Prerequisites
- macOS with Xcode Command Line Tools
- Homebrew
- Ruby 3.3 (via asdf)
- Node.js (via asdf)
- PostgreSQL 16
- Redis

### Installation
```bash
git clone git@github.com:<your-username>/rails8-todo.git
cd rails8-todo
bundle install
npm install
bin/rails db:create db:migrate
bin/dev
