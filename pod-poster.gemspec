require_relative 'lib/pod/poster/version'

Gem::Specification.new do |spec|
  spec.name          = "pod-poster"
  spec.license       = "Apache-2.0"
  spec.version       = Pod::Poster::VERSION
  spec.authors       = ["Mike DeAngelo"]
  spec.email         = ["revmike@gmail.com"]

  spec.summary       = %q{monitor a podcast RSS feed and post to Facebook when a new entry is posted}
  spec.description   = %q{monitor a podcast RSS feed and post to Facebook when a new entry is posted}
  spec.homepage      = "https://github.com/mdeangelo001/pod-poster"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/mdeangelo001/pod-poster"
  #spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_dependency 'httparty', '~> 0.20.0'
  spec.add_dependency 'feedjira', '~> 3.2.1'
  spec.add_dependency 'nokogiri', '~> 1.13.3'
  spec.add_dependency 'koala', '~> 3.1.0'
  spec.add_dependency 'omniauth-facebook', '~> 9.0.0'
end
