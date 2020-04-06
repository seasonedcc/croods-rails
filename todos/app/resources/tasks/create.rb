# frozen_string_literal: true

module Tasks
  class Create < Croods::Service
    about :task

    def execute
      task.save!

      task.list.update!(
        total_tasks: task.list.total_tasks + 1,
        status_text: "#{current_user.name} just created a task."
      )

      task
    end
  end
end
