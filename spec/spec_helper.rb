ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'database_cleaner'
require 'webmock/rspec'
require 'factory_girl_rails'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  puts "Seed: #{RSpec.configuration.seed}"

  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.render_views
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
    begin
      DatabaseCleaner.start
      unless ENV["LINT_DISABLED"]
        puts "Running FactoryGirl.lint"
        FactoryGirl.lint
        puts "Finished FactoryGirl.lint"
      end
    ensure
      DatabaseCleaner.clean
    end
  end
end
