module Repository
  module Adapter
    module Mongo
      class Database < Repository::AbstractDatabase
        def initialize(underlying, connection)
          super
          @underlying = underlying
          @collections = {}
        end

        def collection_names
          @underlying.collection_names
        end

        def collection(name)
          @collections[name] ||= Collection.new(@underlying.collection(name), self)
        end

        def drop
          @underlying.drop
        end
      end
    end
  end
end