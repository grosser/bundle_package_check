module BundlePackageCheck
  class << self
    def errors(all: false, ignore_extra: false)
      expected = expected_from_lock(all)
      actual = Dir["vendor/cache/*"].sort

      errors = []
      errors += (expected - actual).map { |f| "Missing #{f}" }
      errors += (actual - expected).map { |f| "Unnecessary #{f}" } unless ignore_extra
      errors
    end

    private

    def expected_from_lock(all)
      lock = File.read("Gemfile.lock")
      expected = lock.scan(/(?:revision: (\S+)(?:\n  .*)*\n  specs:\n|^)    (\S+) \((\S+)\)/)
      expected.reject! { |revision, _, _| revision } unless all
      expected.map! do |revision, name, version|
        identifier = revision ? revision[0...12] : "#{version}.gem"
        "vendor/cache/#{name}-#{identifier}"
      end.sort!
    end
  end
end
