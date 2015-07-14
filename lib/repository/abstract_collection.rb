module Repository
  class AbstractCollection
    attr_reader :underlying

    def initialize(underlying)
    end

    def name
    end

    def insert(documents)
    end

    def aggregate(*args, **kwargs)
    end
  end
end