# frozen_string_literal: true

module Tasks
  class Show < Croods::Service
    about :task

    def execute
      task.list.update!(
        status_text: "#{current_user.name} just saw a task."
      )

      task
    end
  end
end
