module Repository
  class AbstractCollection
    attr_reader :underlying, :database

    def initialize(underlying, database)
      @database = database
    end

    def name
    end

    def insert(documents)
    end

    def aggregate(*args, **kwargs)
    end
  end
end