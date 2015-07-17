module Api
  module Helper
    def current_project
      Project.find(params[:project_id])
    end

    def decode_data(data)
      decoded = Base64.decode64(data)
      JSON.parse(data)
    end
  end
end