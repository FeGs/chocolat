module Api
  class Queries < Grape::API
    params do
      requires :project_id, type: String, desc: 'A project ID'
    end

    resource :projects do
      params do
        requires :event_collection, type: String, desc: 'A name of event'
      end
      route ['GET', 'POST'], ':project_id/queries/count' do
        require_read_key!

        result = Services::AggregateCount.new(
          current_project, params['event_collection']).execute(params.to_h)
        if result.success?
          { result: result.value }
        else
          { message: result.message }
        end
      end

      params do
        requires :event_collection, type: String, desc: 'A name of event'
        requires :target_property, type: String, desc: 'A name of target property'
      end
      route ['GET', 'POST'], ':project_id/queries/count_unique' do
        require_read_key!

        result = Services::AggregateCountUnique.new(
          current_project, params['event_collection'], params['target_property']).execute(params.to_h)
        if result.success?
          { result: result.value }
        else
          { message: result.message }
        end
      end
    end
  end
end