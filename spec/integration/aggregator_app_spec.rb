require 'spec_helper'
require 'modules/aggregator_app'

describe AggregatorApp do
  include Rack::Test::Methods

  def app
    AggregatorApp
  end

  def api_path
    "#{API_PREFIX}/projects/#{PROJECT_ID}/queries"
  end

  def collection_name
    'commit'
  end

  describe '/projects/:project_id/queries/:method' do
    before :each do
      @collection = database.collection(collection_name)
    end

    after :each do
      database.drop
    end

    describe '#count' do
      it 'counts documents of given event collection' do
        uri = api_path + "/count?event_collection=#{collection_name()}"
        get uri
        expect(json['result']).to eq 0

        @collection.insert({ v: 1 })
        get uri
        expect(json['result']).to eq 1
      end
    end
  end
end