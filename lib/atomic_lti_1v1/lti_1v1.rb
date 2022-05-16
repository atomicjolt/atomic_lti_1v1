module AtomicLti1v1
  class Lti1v1
    def self.is_lti_1v1?(request)
      request.params['oauth_consumer_key'].present?
    end

    def self.valid_timestamp?(request)
      # If timestamp is older than 5 minutes it's invalid
      !(DateTime.strptime(request.params['oauth_timestamp'], '%s') < 5.minutes.ago)
    end

    def self.valid_lti_request?(request, lti_secret, validate_timestamp: true)
      authenticator = IMS::LTI::Services::MessageAuthenticator.new(request.url, request.params,
                                                                   lti_secret)

      result = authenticator.valid_signature? && AtomicLti1v1::Nonce.valid?(request.params['oauth_nonce'])
      if validate_timestamp
        result && valid_timestamp?(request)
      else
        result
      end
    end
  end
end
