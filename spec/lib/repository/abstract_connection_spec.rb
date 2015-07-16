require 'rails_helper'

ADAPTERS.each do |adapter|
  RSpec.describe "#{adapter}: Connection" do
    let(:connection) { Repository::Database.connection(adapter, database: 'test_database') }
    let!(:database) { connection.database }

    after(:each) do
      database.drop
    end

    describe '#adapter_name' do
      it 'is downcased string, not symbol' do
        expect(connection.adapter_name).to eq(adapter.downcase)
      end
    end

    describe '#database_names' do
      it 'returns database names connection has' do
        expect(connection.database_names).not_to include('test_database')
        database['test_collection'].insert({v: 1})
        expect(connection.database_names).to include('test_database')
      end
    end
  end
end