require 'base64'
require 'json'

module IntegrationHelper
  def json
    JSON.parse(last_response.body)
  end

  def encode_data(object)
    Base64.encode64(object.to_json)
  end
end