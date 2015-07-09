require 'sinatra/base'
require 'sinatra/namespace'

class Collector < Sinatra::Base
  register Sinatra::Namespace
end