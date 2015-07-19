module Services
  class AggregateCount < Base
    def initialize(project, event_name)
      @project, @event_name = project, event_name
    end

    def execute(params = {})
      @aggregator = Aggregator.new(@project, @event_name)
      count = @aggregator.count(**params)

      success!(count)
    end
  end
end