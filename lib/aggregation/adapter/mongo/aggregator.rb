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
                _id: group_by(kwargs),
                count: { '$sum' => 1 }
              }
            }
          ])

          if kwargs[:group_by]
            aggregated.map do |document|
              {
                kwargs[:group_by] => document['_id'],
                'result' => document['count']
              }
            end
          else
            result = aggregated.first
            result.try(:[], 'count') || 0
          end
        end

        def group_by(params)
          if params[:group_by]
            "$#{params[:group_by]}"
          else
            nil
          end
        end
      end
    end
  end
end