require 'rails_helper'

RSpec.describe Repository::Database do
  describe '.connection' do
    it 'returns a connection corresponding adapter' do
      ADAPTERS.each do |adapter|
        connection = Repository::Database.connection(adapter)
        expect(connection.adapter_name).to eq(adapter)
      end
    end
  end
end