require 'spec_helper'
require 'modules/collector'

describe Collector do
  include Rack::Test::Methods

  def app
    Collector
  end

  describe '/projects/:project_id/events/:event_name' do
    PROJECT_ID = 'chocolat'
    EVENT_NAME = 'commit'
    API_PATH = "#{API_PREFIX}/projects/#{PROJECT_ID}/events/#{EVENT_NAME}"

    it 'insert a given document' do
      encoded_data = encode_data({a: 1, b: 2})
      uri = API_PATH + "?data=#{encoded_data}"

      get uri
      expect(json['created']).to be true
    end

    it 'complain about invalid data' do
      uri = API_PATH + "?data=123"
      get uri
      expect(json['created']).to be false
    end
  end
end