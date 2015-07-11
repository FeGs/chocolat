require 'sinatra/base'
require 'sinatra/cross_origin'
require 'sinatra/namespace'
require 'sinatra/reloader'

require 'modules/collector_app'
require 'modules/aggregator_app'

class App < Sinatra::Base
  configure :development do
    Mongo::Logger.logger = ::Logger.new('logs/mongo.log')
    Mongo::Logger.logger.level = ::Logger::DEBUG
    enable :logging
    enable :reloader
  end

  register Sinatra::CrossOrigin
  register Sinatra::Reloader

  options "*" do
    cross_origin
  end

  use CollectorApp
  use AggregatorApp

  middleware.each do |middleware, _, _|
    middleware.register Sinatra::CrossOrigin
    middleware.register Sinatra::Namespace

    middleware.configure :development do
      middleware.enable :reloader
      middleware.enable :logging
    end
  end

  run! if app_file == $0
end