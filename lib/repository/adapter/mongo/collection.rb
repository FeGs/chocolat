module Repository
  module Adapter
    module Mongo
      class Collection < Repository::AbstractCollection
        def initialize(underlying, database)
          super
          @underlying = underlying
        end

        def name
          @underlying.name
        end

        def insert(documents)
          if documents.is_a?(Array)
            @underlying.insert_many(documents)
          else
            @underlying.insert_one(documents)
          end
        end

        def aggregate(*args, **kwargs)
          @underlying.find.aggregate(*args, **kwargs)
        end
      end
    end
  end
end