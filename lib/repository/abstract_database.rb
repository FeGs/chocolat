module Repository
  class AbstractDatabase
    attr_reader :underlying, :connection

    def initialize(underlying, connection)
      @connection = connection
    end

    def collection_names
    end

    def collection(name)
    end

    alias_method :[], :collection
  end
end