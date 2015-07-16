module LibHelper
  def clear_repository(project_id)
    Repository::Database.connection(database: project_id).database.drop
  end

  def insert_documents(project_id, event_name, documents)
    db = Repository::Database.connection(database: project_id).database
    db[event_name].insert(documents)
  end
end