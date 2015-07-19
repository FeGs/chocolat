module Services
  class AggregateCountUnique < Base
    def initialize(project, event_name, target_property)
      @project, @event_name, @target_property = project, event_name, target_property
    end

    def execute(params = {})
      @aggregator = Aggregator.new(@project, @event_name)
      count = @aggregator.count_unique(@target_property, **params)

      success!(count)
    end
  end
end