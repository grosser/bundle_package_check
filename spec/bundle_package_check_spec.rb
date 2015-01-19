require "spec_helper"

describe BundlePackageCheck do
  it "has a VERSION" do
    BundlePackageCheck::VERSION.should =~ /^[\.\da-z]+$/
  end
end
