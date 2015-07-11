require 'base64'
require 'json'
require 'sinatra/base'
require 'sinatra/json'
require 'sinatra/jsonp'
require 'sinatra/namespace'
require_relative '../lib/database/database'

class CollectorApp < Sinatra::Base
  register Sinatra::Namespace
  helpers Sinatra::Jsonp

  namespace '/api/v1' do
    namespace '/projects/:project_id' do
      before do
        @project_id = params['project_id']
      end

      get '/events/:event_name' do
        @event_name = params['event_name']
        @data = params['data']

        if @data.nil?
          status 400
          jsonp created: false, msg: 'missing parameter: data'
          return
        end

        begin
          CollectService.new(@project_id, @event_name).execute(@data)
          jsonp created: true
        rescue Exception => e
          status 400
          jsonp created: false, msg: e.message
        end
      end
    end
  end
end

class CollectService
  def initialize(project_id, event_name)
    # Insert document to database immediately now, but should be sent to mq.
    @database ||= Database.connection(database: project_id).database
    @collection ||= @database.collection(event_name)
  end

  def execute(data)
    decoded = Base64::decode64(data)
    @collection.insert(JSON.parse(decoded))
  end
end