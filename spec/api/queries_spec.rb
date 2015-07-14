require 'rails_helper'

RSpec.describe Api::Queries, api: true do
  include ApiHelper

  let(:project_id) { "chocolat" }
  let(:event_name) { "commits" }
  let(:data) { {a: 1, b: 2} }

  after :each do
    clear_repository(project_id)
  end

  describe 'GET|POST /projects/:project_id/queries/count' do
    it 'counts documents of given event collection' do
      # GET
      get api("/projects/#{project_id}/queries/count", event_collection: event_name)
      expect(json_response['result']).to eq 0

      # event insertion
      get api("/projects/#{project_id}/events/#{event_name}", data: encode_data(v: 1))

      # POST
      post api("/projects/#{project_id}/queries/count"), event_collection: event_name
      expect(json_response['result']).to eq 1
    end
  end
end