module Aggregation
  module Adapter
    module Mongo
      class Aggregator
        attr_reader :database, :collection

        def initialize(database, collection)
          @database, @collection = database, collection
        end

        include Helper
        include Count
      end
    end
  end
end