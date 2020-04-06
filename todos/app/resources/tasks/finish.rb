# frozen_string_literal: true

module Tasks
  class Finish
    attr_accessor :task, :user

    def self.execute(task, user)
      new(task, user).execute
    end

    def initialize(task, user)
      self.task = task
      self.user = user
    end

    def execute
      task.update!(finished: true)
      update_list
      task
    end

    private

    def update_list
      list = task.list
      finished_tasks = list.finished_tasks + 1

      list.update!(
        finished_tasks: finished_tasks,
        progress: (finished_tasks.to_f / list.total_tasks * 100).round,
        status_text: "#{user.name} just finished a task."
      )
    end
  end
end
