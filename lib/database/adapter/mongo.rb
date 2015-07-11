require 'mongo'
require_relative '../abstract_database'

module MongoAdapter
  class Connection < AbstractConnection
    def initialize(*args, **kwargs)
      @connection ||= Mongo::Client.new(['127.0.0.1:27017'], **kwargs)
    end

    def adapter_name
      'mongo'
    end

    def database_names
      @connection.database_names
    end

    def database
      Database.new(@connection.database)
    end
  end

  class Database < AbstractDatabase
    def initialize(underlying)
      @underlying ||= underlying
      @collections ||= {}
    end

    def collection_names
      @underlying.collection_names
    end

    def collection(name)
      @collections[name] ||= Collection.new(@underlying.collection(name))
    end

    def drop
      @underlying.drop
    end
  end

  class Collection < AbstractCollection
    def initialize(underlying)
      @underlying ||= underlying
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