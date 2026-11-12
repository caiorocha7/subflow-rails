ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../config/environment", __dir__)
abort("Production mode!") if Rails.env.production?
require "rspec/rails"
RSpec.configure { |config| config.fixture_paths = [] }
