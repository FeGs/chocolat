class AbstractConnection
  def initialize
  end

  def adapter_name
  end

  def database_names
  end

  def database(name)
  end
end

class AbstractDatabase
  def initialize(underlying)
  end

  def collection_names
  end

  def collection(name)
  end

  alias_method :[], :collection
end

class AbstractCollection
  def initialize(underlying)
  end

  def name
  end

  def insert(documents)
  end

  def aggregate(*args, **kwargs)
  end
end