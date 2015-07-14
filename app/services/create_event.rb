module Services
  class CreateEvent < Base
    def initialize(project_id, event_name, data)
      @project_id, @event_name, @data = project_id, event_name, data
    end

    def execute
      begin
        # Insert document to database immediately now, but should be sent to mq.
        database ||= Repository::Database.connection(database: @project_id).database
        collection ||= database.collection(@event_name)
        decoded = Base64::decode64(@data)
        collection.insert(JSON.parse(decoded))
        success!
      rescue JSON::ParserError => e
        error!(e.message)
      end
    end
  end
end