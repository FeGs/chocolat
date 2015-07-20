require 'rails_helper'

RSpec.describe Aggregator do
  include LibHelper

  let(:project) { FactoryGirl.create(:project) }
  let(:event_name) { "commits" }
  let(:data) {
    [
      { author: 'angdev', changes: 2, organization: 'chocolat', repository: { name: 'chocolat' } },
      { author: 'angdev', changes: 3, organization: 'chocolat', repository: { name: 'chocolat-test' } },
      { author: 'hello', changes: 4, organization: 'chocolat', repository: { name: 'chocolat' } }
    ]
  }

  before :each do
    insert_documents(project, event_name, data)
  end

  after :each do
    clear_repository(project)
  end

  describe '#count' do
    it 'counts all documents when no param is given' do
      aggregator = Aggregator.new(project, event_name)
      expect(aggregator.count).to eq(3)
      insert_documents(project, event_name, { author: 'hello', changes: 5 })
      expect(aggregator.count).to eq(4)
    end

    it 'counts documents group by specified property' do
      aggregator = Aggregator.new(project, event_name)
      result = aggregator.count(group_by: 'author')
      expect(result).to match_array([
        { 'author' => 'angdev', 'result' => 2 },
        { 'author' => 'hello', 'result' => 1 }
      ])
    end
  end

  describe '#count_unique' do
    it 'counts unique documents for a target property' do
      aggregator = Aggregator.new(project, event_name)
      result = aggregator.count_unique('author')
      expect(result).to eq(2)
    end

    it 'counts unique documents group by specified property' do
      aggregator = Aggregator.new(project, event_name)
      result = aggregator.count_unique('author', group_by: 'organization')
      expect(result).to match_array([
        { 'organization' => 'chocolat', 'result' => 2 }
      ])
    end

    it 'counts unique documents for a nested target property' do
      aggregator = Aggregator.new(project, event_name)
      result = aggregator.count_unique('repository.name')
      expect(result).to eq(2)

      result = aggregator.count_unique('repository.name', group_by: 'author')
      expect(result).to match_array([
        { 'author' => 'angdev', 'result' => 2, },
        { 'author' => 'hello', 'result' => 1 }
      ])
    end
  end
end