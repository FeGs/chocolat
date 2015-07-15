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
        decode_data! if @data.is_a?(String)
        result = collection.insert(@data)
        success!(result.n)
      rescue JSON::ParserError => e
        error!(e.message)
      end
    end

    def decode_data!
      @data = JSON.parse(Base64::decode64(@data))
    end
  end
end