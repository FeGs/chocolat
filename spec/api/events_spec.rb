require 'rails_helper'

RSpec.describe Api::Events, api: true do
  include ApiHelper

  let(:project_id) { "chocolat" }
  let(:event_name) { "commits" }
  let(:data) { {a: 1, b: 2} }

  after :each do
    clear_repository(project_id)
  end

  describe 'GET /projects/:project_id/events/:event_name' do
    it 'insert a given document' do
      get api("/projects/#{project_id}/events/#{event_name}", data: encode_data(data))
      expect(json_response['created']).to be true
    end

    it 'complain about invalid data' do
      get api("/projects/#{project_id}/events/#{event_name}", data: 123)
      expect(json_response['created']).to be false
    end
  end
end