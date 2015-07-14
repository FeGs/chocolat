require 'rails_helper'

RSpec.describe Aggregator do
  let(:database) { Repository::Database.connection(database: 'test_database').database }
  let!(:collection) { database.collection('test_collection') }

  after :each do
    database.drop
  end

  describe '#count' do
    it 'counts all documents when no param is given' do
      aggregator = Aggregator.new(database, 'test_collection')
      expect(aggregator.count).to eq(0)
      collection.insert({ v: 1 })
      expect(aggregator.count).to eq(1)
    end
  end
end