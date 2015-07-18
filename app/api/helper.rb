module Api
  module Helper
    def current_project
      Project.find(params['project_id'])
    end

    def decode_data(data)
      decoded = Base64.decode64(data)
      JSON.parse(decoded)
    end

    def api_key
      params['api_key'] || headers['Authorization']
    end

    def check_scope(scope)
      scope = scope.to_s
      original_key = current_project.send(scope)

      api_key == original_key.try(:value).try(:to_s)
    end

    def require_read_key!
      error!('Unauthorized', 401) unless check_scope(:read_key) || check_scope(:master_key)
    end

    def require_write_key!
      error!('Unauthorized', 401) unless check_scope(:write_key) || check_scope(:master_key)
    end

    def require_master_key!
      error!('Unauthorized', 401) unless check_scope(:master_key)
    end
  end
end