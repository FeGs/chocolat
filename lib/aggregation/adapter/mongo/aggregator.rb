module Aggregation
  module Adapter
    module Mongo
      class Aggregator
        attr_reader :project, :event_name

        def initialize(project, event_name)
          @project, @event_name = project, event_name
        end

        def collection
          @collection ||= project.repository[event_name]
        end

        include Helper
        include Count
        include CountUnique
      end
    end
  end
end