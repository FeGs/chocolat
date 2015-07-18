module ApiHelper
  def api(path, query = {})
    "/#{Api::EntryPoint.prefix}/#{Api::EntryPoint.version}#{path}?#{query.to_query}"
  end

  def auth_header(key)
    { 'Authorization' => key }
  end

  def encode_data(data)
    Base64.encode64(data.to_json)
  end

  def json_response
    JSON.parse(response.body)
  end

  def clear_repository(project)
    project.repository.drop
  end

  def insert_documents(project, event_name, documents)
    project.repository[event_name].insert(documents)
  end
end