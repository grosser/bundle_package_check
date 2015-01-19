name = "bundle_package_check"
require "./lib/#{name.gsub("-","/")}/version"

Gem::Specification.new name, BundlePackageCheck::VERSION do |s|
  s.summary = "Check if all gems you need are packaged"
  s.authors = ["Michael Grosser"]
  s.email = "michael@grosser.it"
  s.homepage = "https://github.com/grosser/#{name}"
  s.files = `git ls-files lib/ bin/ MIT-LICENSE`.split("\n")
  s.license = "MIT"
end
