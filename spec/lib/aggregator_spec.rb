require 'rails_helper'

RSpec.describe Aggregator do
  include LibHelper

  let(:project) { FactoryGirl.create(:project) }
  let(:event_name) { "commits" }
  let(:data) {
    [
      { author: 'angdev', changes: 2 },
      { author: 'angdev', changes: 3 },
      { author: 'hello', changes: 4 }
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
      aggregator = Aggregator.new(project.repository, event_name)
      expect(aggregator.count).to eq(3)
      project.repository[event_name].insert({ author: 'hello', changes: 5 })
      expect(aggregator.count).to eq(4)
    end

    it 'counts documents group by target property' do
      aggregator = Aggregator.new(project.repository, event_name)
      result = aggregator.count(group_by: 'author')
      expect(result).to match_array([
        { 'author' => 'angdev', 'result' => 2 },
        { 'author' => 'hello', 'result' => 1 }
      ])
    end
  end
end