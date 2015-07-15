require 'rails_helper'

RSpec.describe Services::CreateEvent do
  let(:project_id) { 'chocolat' }
  let(:event_name) { 'commits' }
  let(:data) { Base64.encode64({ v: 1 }.to_json) }
  let(:data_array) { Base64.encode64(Array.new(3, { v: 1 }).to_json) }

  let(:connection) { Repository::Database.connection(database: project_id) }
  let!(:database) { connection.database }
  let!(:collection) { database.collection(event_name) }

  # TEMP: Simple query interface required.
  def event_count
    collection.underlying.find(v: 1).count
  end

  after :each do
    database.drop
  end

  it 'creates an event in project id specific database, collection' do
    expect(event_count).to eq(0)
    expect(connection.database_names).not_to include project_id

    result = Services::CreateEvent.new(project_id, event_name, data).execute
    expect(result.success?).to be true
    expect(event_count).to eq(1)
    expect(connection.database_names).to include project_id
  end

  it 'contains the number of inserted events' do
    expect(event_count).to eq(0)
    result = Services::CreateEvent.new(project_id, event_name, data).execute
    expect(result.success?).to be true
    expect(event_count).to eq(1)
    expect(result.value).to eq(1)
  end

  it 'can create multiple events' do
    expect(event_count).to eq(0)

    result = Services::CreateEvent.new(project_id, event_name, data_array).execute
    expect(result.success?).to be true
    expect(result.value).to eq(3)
    expect(event_count).to eq(3)
  end

  it 'returns ResultError on invalid encoded data' do
    invalid_data = Base64.encode64('123')
    result = Services::CreateEvent.new(project_id, event_name, invalid_data).execute
    expect(result.success?).to be false
  end
end