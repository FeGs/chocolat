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
        result = Services::AggregateCount.new(params['project_id'], params['event_collection']).execute(params.to_h)
        if result.success?
          { result: result.value }
        else
          { message: result.message }
        end
      end
    end
  end
end