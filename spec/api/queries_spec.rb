require 'rails_helper'

RSpec.describe Api::Queries, api: true do
  include ApiHelper

  let(:project) { FactoryGirl.create(:project) }
  let(:project_id) { project.id.to_s }
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

  describe 'GET|POST /projects/:project_id/queries/count' do
    it 'counts documents of given event collection' do
      # GET
      get api("/projects/#{project_id}/queries/count", event_collection: event_name)
      expect(json_response['result']).to eq 3

      # event insertion
      get api("/projects/#{project_id}/events/#{event_name}", data: encode_data({
        author: 'angdev', changes: 4
      }))

      # POST
      post api("/projects/#{project_id}/queries/count"), event_collection: event_name
      expect(json_response['result']).to eq 4
    end

    it 'counts documents grouped by target-property' do
      post api("/projects/#{project_id}/queries/count"), {
        event_collection: event_name,
        group_by: 'author'
      }

      expect(json_response['result']).to match_array([
        { 'author' => 'angdev', 'result' => 2 },
        { 'author' => 'hello', 'result' => 1 }
      ])
    end
  end
end