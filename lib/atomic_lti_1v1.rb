require 'atomic_lti_1v1/version'
require 'atomic_lti_1v1/engine'
require 'atomic_lti_1v1/lti_1v1_middleware'

module AtomicLti1v1
  mattr_accessor :secret_provider
  mattr_accessor :path_prefixes, default: ['/lti_launches']

  class LtiValidationFailed < StandardError; end
end
