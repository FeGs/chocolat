require 'sinatra/base'
require 'sinatra/reloader'
require './modules/collector'

class App < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    Mongo::Logger.logger = ::Logger.new('logs/mongo.log')
    Mongo::Logger.logger.level = ::Logger::DEBUG
  end
  enable :logging

  use Collector

  run! if app_file == $0
end