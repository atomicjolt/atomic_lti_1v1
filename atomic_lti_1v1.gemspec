require_relative 'lib/atomic_lti_1v1/version'

Gem::Specification.new do |spec|
  spec.name        = 'atomic_lti_1v1'
  spec.version     = AtomicLti1v1::VERSION
  spec.authors     = ['Nick Benoit']
  spec.email       = ['nick.benoit@atomicjolt.com']
  spec.homepage    = 'https://github.com/atomicjolt/atomic_lti_1v1'
  spec.summary     = 'Rack middleware to handle validating Lti 1.1 requests'
  spec.description = 'Rack middleware to handle validating Lti 1.1 requests'
  spec.license = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  # spec.metadata["homepage_uri"] = spec.homepage
  # spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  end

  spec.add_dependency 'ims-lti', '~> 2.1.5' # IMS LTI tool consumers and providers
  spec.add_dependency 'rails', '>= 6.1.3'
end
