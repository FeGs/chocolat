module Repository
  class AbstractConnection
    attr_reader :underlying

    def initialize
    end

    def adapter_name
    end

    def database_names
    end

    def database(name)
    end
  end
end