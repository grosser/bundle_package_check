require "spec_helper"

SingleCov.covered!

describe BundlePackageCheck do
  def sh(command, options={})
    result = Bundler.with_clean_env { `#{command} #{"2>&1" unless options[:keep_output]}` }
    raise "#{options[:fail] ? "SUCCESS" : "FAIL"} #{command}\n#{result}" if $?.success? == !!options[:fail]
    result
  end

  let(:folder) { "simple" }

  around do |example|
    Dir.mktmpdir do |dir|
      Dir.chdir(dir) do
        sh "cp -R #{Bundler.root}/spec/cases/#{folder}/* #{dir}"
        example.call
      end
    end
  end

  it "has a VERSION" do
    BundlePackageCheck::VERSION.should =~ /^[\.\da-z]+$/
  end

  describe "with simple gemfile" do
    it "knows when everything is ok" do
      BundlePackageCheck.errors.should == []
    end

    it "knows when something is missing" do
      sh "rm vendor/cache/pru-*"
      BundlePackageCheck.errors.should == ["Missing vendor/cache/pru-0.1.8.gem"]
    end

    it "knows when something is missing" do
      sh "rm vendor/cache/pru-*"
      BundlePackageCheck.errors.should == ["Missing vendor/cache/pru-0.1.8.gem"]
    end

    context "with extra" do
      before { sh "cp vendor/cache/pru-* vendor/cache/other-1.2.3.gem" }

      it "knows when there is extra" do
        BundlePackageCheck.errors.should == ["Unnecessary vendor/cache/other-1.2.3.gem"]
      end

      it "ignores extra with ignore_extra" do
        BundlePackageCheck.errors(ignore_extra: true).should == []
      end

      it "knows when there is extra and missing" do
        sh "rm vendor/cache/pru-*"
        BundlePackageCheck.errors.should == ["Missing vendor/cache/pru-0.1.8.gem", "Unnecessary vendor/cache/other-1.2.3.gem"]
      end
    end
  end

  describe "with unpacked git dependencies" do
    let(:folder) { "git" }

    it "knows everything is ok" do
      BundlePackageCheck.errors.should == []
    end

    it "is not ok when :all is requested" do
      BundlePackageCheck.errors(all: true).should == ["Missing vendor/cache/parallel-6e7afcf22982"]
    end
  end

  describe "with packed git dependencies" do
    let(:folder) { "git_packed" }

    it "knows everything is ok" do
      BundlePackageCheck.errors(all: true).should == []
    end

    it "is not ok when :all is false" do
      BundlePackageCheck.errors.should == ["Unnecessary vendor/cache/parallel-6e7afcf22982", "Unnecessary vendor/cache/testrbl-8299baac0c38"]
    end
  end

  describe "with path dependencies" do
    let(:folder) { "path" }

    it "knows everything is ok" do
      BundlePackageCheck.errors(all: true).should == []
    end

    describe "when path is missing" do
      before { sh "rm -rf vendor/cache/foo" }

      it "is not ok" do
        BundlePackageCheck.errors(all: true).should == ["Missing vendor/cache/foo"]
      end

      it "is ok with ignore_path" do
        BundlePackageCheck.errors(all: true, ignore_path: true).should == []
      end
    end
  end
end
