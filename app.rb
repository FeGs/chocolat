require 'sinatra/base'
require './modules/collector'

class App < Sinatra::Base
  use Collector

  run! if app_file == $0
end