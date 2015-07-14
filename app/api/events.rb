module Api
  class Events < Grape::API
    params do
      requires :project_id, type: String, desc: 'A project ID'
    end

    resource :projects do

      params do
        requires :event_name, type: String, desc: 'A name of event'
        requires :data, type: String, desc: 'A Base64-encoded event document'
      end
      get ':project_id/events/:event_name' do
        result = Services::CreateEvent.new(current_project, params['event_name'], params['data']).execute
        if result.success?
          { created: true }
        else
          { created: false, message: result.message }
        end
      end

    end
  end
end