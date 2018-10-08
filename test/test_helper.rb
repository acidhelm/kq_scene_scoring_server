require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"

VCR.configure do |config|
    config.cassette_library_dir = "test/vcr_cassettes"
    config.debug_logger = File.new("log/test_vcr.log", "a")
    config.default_cassette_options = {
        record: :new_episodes,
        re_record_interval: Rails.configuration.vcr_re_record_time }
    config.hook_into :webmock
end

class ActiveSupport::TestCase
    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
end
