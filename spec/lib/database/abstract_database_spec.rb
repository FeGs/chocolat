require 'spec_helper'
require 'lib/database/database'

ADAPTERS.each do |adapter|
  describe "#{adapter}: Collection" do
    before(:each) do
      @connection = Database.connection(adapter, database: TEST_DATABASE_NAME)
      @database = @connection.database
    end

    after(:each) do
      @database.drop
    end

    describe '#collection' do
      it 'should return the referred collection' do
        collection = @database.collection('my_collection')
        expect(collection.name).to eq('my_collection')
      end
    end

    describe '#collection_names' do
      it 'returns names of collections' do
        expect(@database.collection_names).to be_empty
        collection = @database.collection('my_collection')
        collection.insert({ v: 1 })
        expect(@database.collection_names).to include('my_collection')
      end
    end

    describe '#drop' do
      it 'should drop the database' do
        collection = @database.collection('my_collection')
        collection.insert({ v: 1 })

        expect(@connection.database_names).to include(TEST_DATABASE_NAME)
        @database.drop
        expect(@connection.database_names).not_to include(TEST_DATABASE_NAME)
      end
    end
  end
end