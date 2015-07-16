module Services
  class AggregateCount < Base
    def initialize(project_id, event_collection)
      @project_id, @event_collection = project_id, event_collection
    end

    def execute(params = {})
      params.symbolize_keys!
      @database = Repository::Database.connection(database: @project_id).database
      @aggregator = Aggregator.new(@database, @event_collection)
      count = @aggregator.count(**params)

      success!(count)
    end
  end
end