module Repository
  class AbstractDatabase
    def initialize(underlying)
    end

    def collection_names
    end

    def collection(name)
    end

    alias_method :[], :collection
  end
end