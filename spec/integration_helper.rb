require 'base64'
require 'json'
require 'lib/database/database'

module IntegrationHelper
  def json
    JSON.parse(last_response.body)
  end

  def encode_data(object)
    Base64.encode64(object.to_json)
  end

  def database
    Database.connection(database: TEST_DATABASE_NAME).database
  end
end