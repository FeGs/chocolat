require 'rails_helper'

RSpec.describe Api::Events, api: true do
  include ApiHelper

  let(:project) { FactoryGirl.create(:project) }
  let(:project_id) { project.id.to_s }
  let(:event_name) { "commits" }
  let(:data) { {a: 1, b: 2} }
  let(:write_key) { project.write_key.value }

  after :each do
    clear_repository(project)
  end

  describe 'GET|POST /projects/:project_id/events/:event_name' do
    it 'requires write key' do
      get api("/projects/#{project_id}/events/#{event_name}", data: encode_data(data), api_key: project.read_key.value)
      expect(response).to have_http_status(401)
    end

    it 'inserts a given encoded document (GET)' do
      get api("/projects/#{project_id}/events/#{event_name}", data: encode_data(data), api_key: write_key)
      expect(response).to have_http_status(:success)
      expect(json_response['created']).to be true
    end

    it 'inserts a given document (POST)' do
      post api("/projects/#{project_id}/events/#{event_name}"), data, auth_header(write_key)
      expect(response).to have_http_status(:success)
      expect(json_response['created']).to be true
    end

    it 'complains about invalid data' do
      get api("/projects/#{project_id}/events/#{event_name}", data: 123, api_key: write_key)
      expect(response).to have_http_status(:success)
      expect(json_response['created']).to be false
    end
  end

  describe 'POST /projects/:project_id/events' do
    it 'requires write key' do
      post api("/projects/#{project_id}/events"), { commits: [{v: 1}] }, auth_header(project.read_key.value)
      expect(response).to have_http_status(401)
    end

    it 'inserts multiple documents to correspond collection' do
      post api("/projects/#{project_id}/events"), {
        commits: [{v: 1}, {v: 2}],
        pushes: [{u: 1}, {u: 2}]
      }, auth_header(write_key)

      expect(response).to have_http_status(:success)
      expect(json_response.with_indifferent_access).to eq({
        commits: [{success: true}, {success: true}],
        pushes: [{success: true}, {success: true}]
      }.with_indifferent_access)
    end

    it 'inserts documents partially if some documents are invalid' do
      post api("/projects/#{project_id}/events"), {
        commits: [{v: 1}, 1]
      }, auth_header(write_key)

      expect(response).to have_http_status(:success)
      expect(json_response.with_indifferent_access).to eq({
        commits: [{success: true}, {success: false}]
      }.with_indifferent_access)
    end

    it 'accepts only values which are all instance of Array' do
      post api("/projects/#{project_id}/events"), {
        commits: {v: 1}
      }, auth_header(write_key)

      expect(response).to have_http_status(:error)
    end
  end
end