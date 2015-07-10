require_relative './adapter/mongo'

class Database
  def self.connection(driver = 'mongo', *args, **kwargs)
    case driver
    when 'mongo'
      MongoAdapter::Connection.new(*args, **kwargs)
    end
  end
end