require_relative './adapter/mongo'

class Database
  def self.connection(driver, *args, **kwargs)
    case driver
    when 'mongo'
      MongoAdapter::Connection.new(*args, **kwargs)
    end
  end
end