require "bundler/setup"

require "single_cov"
SingleCov.setup :rspec

require "bundle_package_check/version"
require "bundle_package_check"
require "tmpdir"

RSpec.configure do |config|
  config.expect_with(:rspec) { |c| c.syntax = :should }
  config.mock_with(:rspec) { |c| c.syntax = :should }
end
