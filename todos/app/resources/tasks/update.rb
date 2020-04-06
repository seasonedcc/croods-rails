# frozen_string_literal: true

module Tasks
  class Update < Croods::Service
    about :task

    def execute
      task.update!(params)

      task.list.update!(
        status_text: "#{current_user.name} just updated a task."
      )

      task
    end
  end
end
