# frozen_string_literal: true

module Tasks
  class Index < Croods::Service
    about :tasks

    def execute
      list.update!(
        status_text: "#{current_user.name} just saw this list."
      )

      tasks
    end

    def list
      @list ||= List.find(params[:list_id])
    end
  end
end
