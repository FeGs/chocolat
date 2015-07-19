module Aggregation
  module Adapter
    module Mongo
      module CountUnique
        def count_unique(target_property, **kwargs)
          performer = CountUniquePerformer.new(collection, target_property, **kwargs)
          performer.perform
        end

        class CountUniquePerformer < Performer
          attr_reader :target_property

          def initialize(collection, target_property, **kwargs)
            super(collection, **kwargs)
            @target_property = target_property
          end

          def perform
            aggregated = collection.aggregate(aggregate_pipeline)

            if params[:group_by]
              result = aggregated.map do |document|
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
            stage1['$group']['_id'] = {}
            stage1['$group']['_id'][target_property] = to_variable(target_property)
            stage1['$group']['_id'][params[:group_by]] = to_variable(params[:group_by]) if params[:group_by]

            stage2 = {}
            stage2['$group'] = {}
            stage2['$group']['_id'] = to_variable('_id', params[:group_by])
            stage2['$group']['count'] = { '$sum' => 1 }

            [stage1, stage2]
          end
        end
      end
    end
  end
end
