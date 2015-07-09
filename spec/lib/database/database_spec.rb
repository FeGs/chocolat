require 'spec_helper'
require 'lib/database/database'

ADAPTERS = %w(mongo)

describe Database do
  describe '.connection' do
    it 'returns a connection corresponding adapter' do
      ADAPTERS.each do |adapter|
        connection = Database.connection(adapter)
        expect(connection.adapter_name).to eq(adapter)
      end
    end
  end
end