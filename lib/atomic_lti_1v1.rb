require 'atomic_lti_1v1/version'
require 'atomic_lti_1v1/engine'
require 'atomic_lti_1v1/lti_1v1_middleware'

module AtomicLti1v1
  mattr_accessor :secret_provider

  class LtiValidationFailed < StandardError; end
end
