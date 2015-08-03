module BundlePackageCheck
  PATH_SECTION = /^PATH\n(  .*\n)+/

  class << self
    def errors(all: false, ignore_extra: false, ignore_path: false)
      expected = expected_from_lock(all, ignore_path)
      actual = Dir["vendor/cache/*"].sort

      errors = []
      errors += (expected - actual).map { |f| "Missing #{f}" }
      errors += (actual - expected).map { |f| "Unnecessary #{f}" } unless ignore_extra
      errors
    end

    private

    def path_gems(lock)
      if section = lock[PATH_SECTION]
        section.scan(/^    (\S+)/).flatten
      else
        []
      end
    end

    def expected_from_lock(all, ignore_path)
      lock = File.read("Gemfile.lock")
      path_gems = path_gems(lock)
      expected = lock.scan(/(?:revision: (\S+)(?:\n  .*)*\n  specs:\n|^)    (\S+) \((\S+)\)/)
      expected.reject! { |revision, _, _| revision } unless all
      expected.reject! { |_, name, _| path_gems.include?(name) } if ignore_path
      expected.map! do |revision, name, version|
        identifier = (revision ? "-#{revision[0...12]}" : (path_gems.include?(name) ? "" : "-#{version}.gem"))
        "vendor/cache/#{name}#{identifier}"
      end.sort!
    end
  end
end
