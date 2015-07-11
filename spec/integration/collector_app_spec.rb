require 'spec_helper'
require 'modules/collector_app'

describe CollectorApp do
  include Rack::Test::Methods

  def app
    CollectorApp
  end

  def api_path
    "#{API_PREFIX}/projects/#{PROJECT_ID}/events/#{event_name}"
  end

  def event_name
    'commit'
  end

  describe '/projects/:project_id/events/:event_name' do
    it 'insert a given document' do
      encoded_data = encode_data({a: 1, b: 2})
      uri = api_path + "?data=#{encoded_data}"

      get uri
      expect(json['created']).to be true
    end

    it 'complain about invalid data' do
      uri = api_path + "?data=123"
      get uri
      expect(json['created']).to be false
    end
  end
end