module Repository
  class Database
    def self.connection(driver = 'mongo', *args, **kwargs)
      case driver
      when 'mongo'
        Adapter::Mongo::Connection.new(*args, **kwargs)
      end
    end
  end
end