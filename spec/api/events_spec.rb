require 'rails_helper'

RSpec.describe Api::Events, api: true do
  include ApiHelper

  let(:project_id) { "chocolat" }
  let(:event_name) { "commits" }
  let(:data) { {a: 1, b: 2} }

  after :each do
    clear_repository(project_id)
  end

  describe 'GET|POST /projects/:project_id/events/:event_name' do
    it 'inserts a given encoded document (GET)' do
      get api("/projects/#{project_id}/events/#{event_name}", data: encode_data(data))
      expect(response).to be_success
      expect(json_response['created']).to be true
    end

    it 'inserts a given document (POST)' do
      post api("/projects/#{project_id}/events/#{event_name}"), data
      expect(response).to be_success
      expect(json_response['created']).to be true
    end

    it 'complains about invalid data' do
      get api("/projects/#{project_id}/events/#{event_name}", data: 123)
      expect(response).to be_success
      expect(json_response['created']).to be false
    end
  end

  describe 'POST /projects/:project_id/events' do
    it 'inserts multiple documents to correspond collection' do
      post api("/projects/#{project_id}/events"), {
        commits: [{v: 1}, {v: 2}],
        pushes: [{u: 1}, {u: 2}]
      }
      expect(response).to be_success
      expect(json_response.with_indifferent_access).to eq({
        commits: [{success: true}, {success: true}],
        pushes: [{success: true}, {success: true}]
      }.with_indifferent_access)
    end

    it 'inserts documents partially if some documents are invalid' do
      post api("/projects/#{project_id}/events"), {
        commits: [{v: 1}, 1]
      }
      expect(response).to be_success
      expect(json_response.with_indifferent_access).to eq({
        commits: [{success: true}, {success: false}]
      }.with_indifferent_access)
    end

    it 'accepts only values which are all instance of Array' do
      post api("/projects/#{project_id}/events"), {
        commits: {v: 1}
      }
      expect(response).to be_error
    end
  end
end