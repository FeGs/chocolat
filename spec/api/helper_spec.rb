require 'rails_helper'

RSpec.describe Api::Helper do
  class RequestMock
    include Api::Helper

    attr_reader :params, :headers

    def initialize(params = {}, headers = {})
      @params, @headers = params, headers
      @params.stringify_keys!
      @headers.stringify_keys!
    end

    def error!(msg, status_code)
      raise StandardError, "#{status_code}: #{msg}"
    end
  end

  let(:project) { FactoryGirl.create(:project) }
  let(:project_id) { project.id.to_s }

  describe '#current_project' do
    it 'returns a project for given project id' do
      request = RequestMock.new(project_id: project_id)
      expect(request.current_project).to eq project
    end
  end

  describe '#decode_data' do
    it 'decodes base64 encoded json' do
      data = { 'v' => 1 }
      encoded_data = Base64.encode64(data.to_json)

      request = RequestMock.new
      decoded_data = request.decode_data(encoded_data)
      expect(decoded_data).to eq(data)
    end

    it 'raises error if given data is invalid' do
      data = 1
      encoded_data = Base64.encode64(data.to_s)

      request = RequestMock.new
      expect { request.decode_data(encoded_data) }.to raise_error(JSON::ParserError)
    end
  end

  describe '#api_key' do
    it 'returns an api key regardless of method' do
      request = RequestMock.new(api_key: 'abcd')
      expect(request.api_key).to eq('abcd')

      request = RequestMock.new({}, 'Authorization' => 'abcd')
      expect(request.api_key).to eq('abcd')
    end

    it 'gives api_key from query parameters priority over from headers' do
      request = RequestMock.new({ api_key: 'abcd' }, { 'Authorization' => 'dcba' })
      expect(request.api_key).to eq('abcd')
    end
  end

  describe '#check_scope' do
    it 'checks whether given api_key is satisfied with required scope' do
      request = RequestMock.new(project_id: project_id, api_key: project.read_key.value)
      expect(request.check_scope('read_key')).to be true
      expect(request.check_scope('write_key')).to be false
    end
  end

  describe '#require_read_key!' do
    it 'checks whether given api_key is satisfied with read_key scope' do
      request = RequestMock.new(project_id: project_id, api_key: project.read_key.value)
      expect { request.require_read_key! }.not_to raise_error

      request = RequestMock.new(project_id: project_id, api_key: project.master_key.value)
      expect { request.require_read_key! }.not_to raise_error

      request = RequestMock.new(project_id: project_id, api_key: project.write_key.value)
      expect { request.require_read_key! }.to raise_error('401: Unauthorized')
    end
  end

  describe '#require_write_key!' do
    it 'checks whether given api_key is satisfied with write_key scope' do
      request = RequestMock.new(project_id: project_id, api_key: project.write_key.value)
      expect { request.require_write_key! }.not_to raise_error

      request = RequestMock.new(project_id: project_id, api_key: project.master_key.value)
      expect { request.require_write_key! }.not_to raise_error

      request = RequestMock.new(project_id: project_id, api_key: project.read_key.value)
      expect { request.require_write_key! }.to raise_error('401: Unauthorized')
    end
  end

  describe '#require_master_key!' do
    it 'checks whether given api_key is satisfied with master_key scope' do
      request = RequestMock.new(project_id: project_id, api_key: project.master_key.value)
      expect { request.require_master_key! }.not_to raise_error

      request = RequestMock.new(project_id: project_id, api_key: project.read_key.value)
      expect { request.require_master_key! }.to raise_error('401: Unauthorized')

      request = RequestMock.new(project_id: project_id, api_key: project.write_key.value)
      expect { request.require_master_key! }.to raise_error('401: Unauthorized')
    end
  end
end