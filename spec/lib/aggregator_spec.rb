require 'spec_helper'
require 'lib/aggregator'

describe Aggregator do
  before :each do
    @database = database
    @collection = @database.collection('test_collection')
  end

  after :each do
    @database.drop
  end

  describe '#count' do
    it 'counts all documents when no param is given' do
      aggregator = Aggregator.new(@database, 'test_collection')
      expect(aggregator.count).to eq(0)
      @collection.insert({ v: 1 })
      expect(aggregator.count).to eq(1)
    end
  end
end