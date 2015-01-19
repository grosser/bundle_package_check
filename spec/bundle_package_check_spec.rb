require "spec_helper"

describe BundlePackageCheck do
  def sh(command, options={})
    result = Bundler.with_clean_env { `#{command} #{"2>&1" unless options[:keep_output]}` }
    raise "#{options[:fail] ? "SUCCESS" : "FAIL"} #{command}\n#{result}" if $?.success? == !!options[:fail]
    result
  end

  around do |example|
    Dir.mktmpdir do |dir|
      Dir.chdir(dir) do
        sh "cp -R #{Bundler.root}/spec/cases/simple/* #{dir}"
        example.call
      end
    end
  end

  it "has a VERSION" do
    BundlePackageCheck::VERSION.should =~ /^[\.\da-z]+$/
  end

  describe "with simple gemfile" do
    it "knows when everything is ok" do
      BundlePackageCheck.check.should == nil
    end

    it "knows when something is missing" do
      sh "rm vendor/cache/pru-*"
      BundlePackageCheck.check.should == ["Missing vendor/cache/pru-0.1.8.gem"]
    end

    it "knows when something is missing" do
      sh "rm vendor/cache/pru-*"
      BundlePackageCheck.check.should == ["Missing vendor/cache/pru-0.1.8.gem"]
    end

    it "knows when there is extra" do
      sh "cp vendor/cache/pru-* vendor/cache/other-1.2.3.gem"
      BundlePackageCheck.check.should == ["Unnecessary vendor/cache/other-1.2.3.gem"]
    end

    it "knows when there is extra and missing" do
      sh "cp vendor/cache/pru-* vendor/cache/other-1.2.3.gem"
      sh "rm vendor/cache/pru-*"
      BundlePackageCheck.check.should == ["Missing vendor/cache/pru-0.1.8.gem", "Unnecessary vendor/cache/other-1.2.3.gem"]
    end
  end
end
