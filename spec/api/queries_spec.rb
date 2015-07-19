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
  let(:read_key) { project.read_key.value }

  before :each do
    insert_documents(project, event_name, data)
  end

  after :each do
    clear_repository(project)
  end

  describe 'GET|POST /projects/:project_id/queries/count' do
    it 'requires read key' do
      get api("/projects/#{project_id}/queries/count", event_collection: event_name, api_key: project.write_key.value)
      expect(response).to have_http_status(401)
    end

    it 'counts documents of given event collection' do
      get api("/projects/#{project_id}/queries/count", event_collection: event_name, api_key: read_key)

      expect(response).to have_http_status(:success)
      expect(json_response['result']).to eq 3
    end

    it 'counts documents grouped by specified property' do
      post api("/projects/#{project_id}/queries/count"), {
        event_collection: event_name,
        group_by: 'author'
      }, auth_header(read_key)

      expect(response).to have_http_status(:success)
      expect(json_response['result']).to match_array([
        { 'author' => 'angdev', 'result' => 2 },
        { 'author' => 'hello', 'result' => 1 }
      ])
    end
  end

  describe 'GET|POST /projects/:project_id/queries/count_unique' do
    it 'requires read key' do
      get api("/projects/#{project_id}/queries/count",
        event_collection: event_name,
        target_property: 'author',
        api_key: project.write_key.value)

      expect(response).to have_http_status(401)
    end

    it 'requires a target property' do
      get api("/projects/#{project_id}/queries/count_unique",
        event_collection: event_name,
        api_key: read_key)

      expect(response).to have_http_status(400)
    end

    it 'counts unique documents for a target property' do
      get api("/projects/#{project_id}/queries/count_unique",
        event_collection: event_name,
        target_property: 'author',
        api_key: read_key)

      expect(response).to have_http_status(:success)
      expect(json_response['result']).to eq 2
    end

    it 'counts unique documents grouped by specified property' do
      post api("/projects/#{project_id}/queries/count_unique"), {
        event_collection: event_name,
        target_property: 'author',
        group_by: 'author'
      }, auth_header(read_key)

      expect(response).to have_http_status(:success)
      expect(json_response['result']).to match_array([
        { 'author' => 'angdev', 'result' => 1 },
        { 'author' => 'hello', 'result' => 1 }
      ])
    end
  end
end