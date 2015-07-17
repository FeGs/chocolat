module LibHelper
  def clear_repository(project)
    project.repository.drop
  end

  def insert_documents(project, event_name, documents)
    project.repository[event_name].insert(documents)
  end
end