require 'rails_helper'

ADAPTERS.each do |adapter|
  RSpec.describe "#{adapter}: Collection" do
    let(:connection) { Repository::Database.connection(adapter, database: 'test_database') }
    let!(:database) { connection.database }
    let!(:collection) { database.collection('test_collection') }

    after(:each) do
      database.drop
    end

    describe '#insert' do
      it 'allow a document to be inserted' do
        result = collection.insert({ v: 2 })
        expect(result.n).to eq(1)
      end

      it 'allow multiple document to be inserted' do
        result = collection.insert([{ v: 2 }, { v: 5 }])
        expect(result.n).to eq(2)
      end
    end
  end
end