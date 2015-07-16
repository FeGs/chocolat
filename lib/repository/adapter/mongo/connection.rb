module Repository
  module Adapter
    module Mongo
      class Connection < AbstractConnection
        def initialize(*args, **kwargs)
          @underlying = ::Mongo::Client.new(['127.0.0.1:27017'], **kwargs)
        end

        def adapter_name
          'mongo'
        end

        def database_names
          @underlying.database_names
        end

        def database
          Adapter::Mongo::Database.new(@underlying.database, self)
        end
      end
    end
  end
end