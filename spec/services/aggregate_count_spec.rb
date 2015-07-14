require 'rails_helper'

RSpec.describe Services::AggregateCount do
  let(:project_id) { 'chocolat' }
  let(:event_name) { 'commits' }

  let(:connection) { Repository::Database.connection(database: project_id) }
  let!(:database) { connection.database }
  let!(:collection) { database.collection(event_name) }

  after :each do
    database.drop
  end

  it 'counts just the number of events for no given condition' do
    result = Services::AggregateCount.new(project_id, event_name).execute
    expect(result.success?).to be true
    expect(result.value).to eq(0)

    collection.insert(v: 1)
    result = Services::AggregateCount.new(project_id, event_name).execute
    expect(result.success?).to be true
    expect(result.value).to eq(1)
  end
end