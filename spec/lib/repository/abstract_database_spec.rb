require 'rails_helper'

ADAPTERS.each do |adapter|
  RSpec.describe "#{adapter}: Collection" do
    let(:connection) { Repository::Database.connection(adapter, database: 'test_database') }
    let!(:database) { connection.database }

    after(:each) do
      database.drop
    end

    describe '#collection' do
      it 'should return the referred collection' do
        collection = database.collection('my_collection')
        expect(collection.name).to eq('my_collection')
      end
    end

    describe '#collection_names' do
      it 'returns names of collections' do
        expect(database.collection_names).to be_empty
        collection = database.collection('my_collection')
        collection.insert({ v: 1 })
        expect(database.collection_names).to include('my_collection')
      end
    end

    describe '#drop' do
      it 'should drop the database' do
        collection = database.collection('my_collection')
        collection.insert({ v: 1 })

        expect(connection.database_names).to include('test_database')
        database.drop
        expect(connection.database_names).not_to include('test_database')
      end
    end
  end
end