# frozen_string_literal: true

module Tasks
  class Destroy < Croods::Service
    about :task

    def execute
      task.destroy!

      task.list.update!(
        total_tasks: task.list.total_tasks - 1,
        status_text: "#{current_user.name} just deleted a task."
      )

      task
    end
  end
end
