module Repository
  class AbstractDatabase
    attr_reader :underlying, :connection

    def initialize(underlying, connection)
      @connection = connection
    end

    def adapter_name
      connection.adapter_name
    end

    def collection_names
    end

    def [](name)
    end

    alias_method :collection, :[]
  end
end