require 'sinatra/base'
require 'sinatra/cross_origin'
require 'sinatra/namespace'
require 'sinatra/jsonp'
require_relative '../lib/database/database'
require_relative '../lib/aggregator'

class AggregatorApp < Sinatra::Base
  register Sinatra::CrossOrigin
  register Sinatra::Namespace

  helpers Sinatra::Jsonp

  namespace '/api/v1' do
    namespace '/projects/:project_id' do
      before do
        @project_id = params['project_id']
      end

      post '/queries/count' do
        cross_origin

        request.body.rewind
        body = request.body.read
        @params ||= {}
        @params.merge!(JSON.parse(body)) if body.length > 0

        @event_collection = params['event_collection']
        if @event_collection.nil?
          status 400
          jsonp msg: 'missing parameter: event_collection'
          return
        end

        begin
          count = AggregateCountService.new(@project_id, @event_collection).execute(params)
          jsonp result: count
        rescue Exception => e
          status 400
          jsonp msg: e.message
        end
      end
    end
  end
end

class AggregateCountService
  def initialize(project_id, event_collection)
    @database = Database.connection(database: project_id).database
    @aggregator = Aggregator.new(@database, event_collection)
  end

  def execute(params)
    @aggregator.count(**params)
  end
end