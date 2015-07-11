require 'spec_helper'
require 'lib/database/database'

ADAPTERS.each do |adapter|
  describe 'AbstractCollection' do
    before(:each) do
      @connection = Database.connection(adapter, database: TEST_DATABASE_NAME)
      @database = @connection.database
      @collection = @database.collection('test_collection')
    end

    after(:each) do
      @database.drop
    end

    describe '#insert' do
      it 'allow a document to be inserted' do
        result = @collection.insert({ v: 2 })
        expect(result.n).to eq(1)
      end

      it 'allow multiple document to be inserted' do
        result = @collection.insert([{ v: 2 }, { v: 5 }])
        expect(result.n).to eq(2)
      end
    end

    describe '#aggregate' do
      skip
    end
  end
end