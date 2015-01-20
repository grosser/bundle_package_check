Check if all gems you need are packaged / vendored,
super fast and without bundler.

Install
=======

```Bash
gem install bundle_package_check
```

Usage
=====

```Ruby
error = BundlePackageCheck.errors
if errors.any?
  puts errors
  abort
end
==>
Missing vendor/cache/xxx-123.gem
Unnecessary vendor/cache/yyy-123.gem
```

check with `:all` mode to see if git dependencies are properly packaged

```Ruby
error = BundlePackageCheck.errors all: true
raise errors.inspect if errors.any?
```

Author
======
[Michael Grosser](http://grosser.it)<br/>
michael@grosser.it<br/>
License: MIT<br/>
[![Build Status](https://travis-ci.org/grosser/bundle_package_check.png)](https://travis-ci.org/grosser/bundle_package_check)
