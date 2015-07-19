module Aggregation
  module Adapter
    module Mongo
      module Count
        def count(**kwargs)
          performer = CountPerformer.new(collection, **kwargs)
          performer.perform
        end

        class CountPerformer < Performer
          def initialize(collection, **kwargs)
            super(collection, **kwargs)
          end

          def perform
            aggregated = collection.aggregate(aggregate_pipeline)

            if params[:group_by]
              aggregated.map do |document|
                {
                  params[:group_by] => document['_id'],
                  'result' => document['count']
                }
              end
            else
              result = aggregated.first
              result.try(:[], 'count') || 0
            end
          end

        private
          def aggregate_pipeline
            stage1 = {}
            stage1['$group'] = {}
            stage1['$group']['_id'] = to_variable(params[:group_by])
            stage1['$group']['count'] = { '$sum' => 1 }

            [stage1]
          end
        end

      end
    end
  end
end
