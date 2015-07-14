class Aggregator
  def initialize(database, collection_name)
    @database = database
    @collection = @database.collection(collection_name)
  end

  def count(**kwargs)
    aggregated = @collection.aggregate([
      {
        '$group' => {
          _id: nil,
          count: { '$sum' => 1 }
        }
      }
    ])

    result = aggregated.first

    if result.nil?
      0
    else
      result['count']
    end
  end
end