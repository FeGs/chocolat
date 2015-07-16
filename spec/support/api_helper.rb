module ApiHelper
  def api(path, query = {})
    "/#{Api::EntryPoint.prefix}/#{Api::EntryPoint.version}#{path}?#{query.to_query}"
  end

  def encode_data(data)
    Base64.encode64(data.to_json)
  end

  def json_response
    JSON.parse(response.body)
  end

  def clear_repository(project_id)
    Repository::Database.connection(database: project_id).database.drop
  end

  def insert_documents(project_id, event_name, documents)
    db = Repository::Database.connection(database: project_id).database
    db[event_name].insert(documents)
  end
end