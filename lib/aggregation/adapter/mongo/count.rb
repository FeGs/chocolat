module Aggregation
  module Adapter
    module Mongo
      module Count
        def count(**kwargs)
          aggregated = collection.aggregate([
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
      end
    end
  end
end
