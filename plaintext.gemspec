lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'plaintext/version'

Gem::Specification.new do |spec|
  spec.name = 'plaintext'
  spec.version = Plaintext::VERSION
  spec.authors = ['gustin']
  spec.email = ['gustin@users.noreply.github.com']

  spec.summary = %q{Write a short summary, because RubyGems requires one.}
  spec.description = %q{Write a longer description or delete this line.}
  spec.homepage = 'https://www.getplaintext.com'

  spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/plaintest'
  spec.metadata['changelog_uri'] = 'https://github.com/planintext/CHANGELOG'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'ffi'
  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'm', '~> 1.5.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
end
