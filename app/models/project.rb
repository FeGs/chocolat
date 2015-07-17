class Project < ActiveRecord::Base
  include ActiveUUID::UUID
  has_many :api_keys

  before_create :generate_api_keys!

  ApiKey::SCOPES.each do |scope|
    define_method scope do
      api_keys.send(scope).permitted.take
    end
  end

  def repository
    Repository::Database.connection(database: id).try(:database)
  end

private
  def generate_api_keys!
    ApiKey::SCOPES.each do |scope|
      api_keys.build(scope: scope.to_s)
    end
  end
end
