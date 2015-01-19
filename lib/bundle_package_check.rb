module BundlePackageCheck
  class << self
    def check
      expected = File.read("Gemfile.lock").scan(/^    (\S+) \((\S+)\)/).map { |gem, version| "vendor/cache/#{gem}-#{version}.gem" }.sort
      actual = Dir["vendor/cache/*"]
      return if actual == expected

      errors = []
      errors += (expected - actual).map { |f| "Missing #{f}" }
      errors += (actual - expected).map { |f| "Unnecessary #{f}" }
      errors
    end
  end
end
