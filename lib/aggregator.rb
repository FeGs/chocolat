class Aggregator
  extend Forwardable

  def initialize(database, collection_name)
    @database = database
    @collection = @database.collection(collection_name)
  end

  def adapter
    @adapter ||= begin
      case @database.adapter_name
      when 'mongo'
        Aggregation::Adapter::Mongo::Aggregator.new(@database, @collection)
      end
    end
  end

  def_delegators :adapter, :count
end