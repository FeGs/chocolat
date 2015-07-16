module Aggregation
  module Adapter
    module Mongo
      class Aggregator
        def initialize(database, collection)
          @database, @collection = database, collection
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
    end
  end
end