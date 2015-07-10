require 'mongo'
require 'json'
require 'rack/test'
require 'rspec'
require_relative './integration_helper'

$:.unshift File.join(File.dirname(__FILE__), '..')

# Suppress mongo log
Mongo::Logger.logger.level = ::Logger::FATAL

API_PREFIX = '/api/v1'
ADAPTERS = %w(mongo)

RSpec.configure do |config|
  config.include IntegrationHelper

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  config.example_status_persistence_file_path = "spec/examples.txt"

  # config.warnings = true

  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end

  config.profile_examples = 10

  config.order = :random
  Kernel.srand config.seed
end
