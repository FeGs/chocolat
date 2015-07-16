require 'rails_helper'

RSpec.describe Aggregator do
  include LibHelper

  let(:project_id) { "chocolat" }
  let(:event_name) { "commits" }
  let(:data) {
    [
      { author: 'angdev', changes: 2 },
      { author: 'angdev', changes: 3 },
      { author: 'hello', changes: 4 }
    ]
  }

  let(:database) { Repository::Database.connection(database: project_id).database }
  let!(:collection) { database.collection(event_name) }

  before :each do
    insert_documents(project_id, event_name, data)
  end

  after :each do
    clear_repository(project_id)
  end

  describe '#count' do
    it 'counts all documents when no param is given' do
      aggregator = Aggregator.new(database, event_name)
      expect(aggregator.count).to eq(3)
      collection.insert({ author: 'hello', changes: 5 })
      expect(aggregator.count).to eq(4)
    end

    it 'counts documents group by target property' do
      aggregator = Aggregator.new(database, event_name)
      result = aggregator.count(group_by: 'author')
      expect(result).to match_array([
        { 'author' => 'angdev', 'result' => 2 },
        { 'author' => 'hello', 'result' => 1 }
      ])
    end
  end
end