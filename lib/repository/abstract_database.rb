module Repository
  class AbstractDatabase
    attr_reader :underlying

    def initialize(underlying)
    end

    def collection_names
    end

    def collection(name)
    end

    alias_method :[], :collection
  end
end