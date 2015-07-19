class Aggregator
  extend Forwardable

  def initialize(project, event_name)
    @project, @event_name = project, event_name
  end

  def repository
    @project.repository
  end

  def adapter
    @adapter ||= begin
      case repository.adapter_name
      when 'mongo'
        Aggregation::Adapter::Mongo::Aggregator.new(@project, @event_name)
      end
    end
  end

  def_delegators :adapter, :count, :count_unique
end