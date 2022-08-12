module AtomicLti1v1
  class Lti1v1
    def self.is_lti_1v1?(request)
      contains_oauth_consumer_key = request.params['oauth_consumer_key'].present? 
      path_matches = request.env["PATH_INFO"].match(AtomicLti1v1.lti_launch_path_regex)&.size == 1

      path_matches && contains_oauth_consumer_key
    end

    def self.valid_timestamp?(request)
      # If timestamp is older than 5 minutes it's invalid
      !(DateTime.strptime(request.params['oauth_timestamp'], '%s') < 5.minutes.ago)
    end

    def self.valid_lti_request?(request, lti_secret)
      authenticator = IMS::LTI::Services::MessageAuthenticator.new(request.url, request.params,
                                                                   lti_secret)

      authenticator.valid_signature? &&
        AtomicLti1v1::Nonce.valid?(request.params['oauth_nonce']) &&
        valid_timestamp?(request)
    end
  end
end
