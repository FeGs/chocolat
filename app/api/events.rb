module Api
  class Events < Grape::API
    rescue_from ArgumentError

    params do
      requires :project_id, type: String, desc: 'A project ID'
    end

    resource :projects do

      post ':project_id/events' do
        require_write_key!

        documents = params.except(:project_id)
        result = documents.map do |event_name, data_array|
          raise ArgumentError unless data_array.is_a?(Array)
          result = data_array.map do |data|
            result = Services::CreateEvent.new(current_project, event_name, data).execute
            if result.success?
              { success: true }
            else
              { success: false }
            end
          end

          [event_name, result]
        end

        result.to_h
      end

      params do
        requires :event_name, type: String, desc: 'A name of event'
        requires :data, type: String, desc: 'A Base64-encoded event document'
      end
      get ':project_id/events/:event_name' do
        require_write_key!

        result = Services::CreateEvent.new(current_project, params['event_name'], params['data']).execute
        if result.success?
          { created: true }
        else
          { created: false, message: result.message }
        end
      end

      params do
        requires :event_name, type: String, desc: 'A name of event'
      end
      post ':project_id/events/:event_name' do
        require_write_key!

        data = params.except(:project_id)
        result = Services::CreateEvent.new(current_project, params['event_name'], data).execute
        if result.success?
          { created: true }
        else
          { created: false, message: result.message }
        end
      end

    end
  end
end