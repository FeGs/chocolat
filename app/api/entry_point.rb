module Api
  class EntryPoint < Grape::API
    version 'v1', using: :path
    prefix :api

    format :json

    helpers Helper

    mount Events
    mount Queries
  end
end