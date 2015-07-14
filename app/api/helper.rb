module Api
  module Helper
    def current_project
      params[:project_id]
    end
  end
end