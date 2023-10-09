require_relative 'lti_1v1'
module AtomicLti1v1
  class Lti1v1Middleware
    def initialize(app)
      @app = app
    end

    def matches_path_prefixes?(request)
      AtomicLti1v1.path_prefixes.any? do |prefix|
        request.path.starts_with? prefix
      end
    end

    def call(env)
      request = Rack::Request.new(env)
      if matches_path_prefixes?(request) && AtomicLti1v1::Lti1v1.is_lti_1v1?(request)
        oauth_consumer_key = request.params['oauth_consumer_key']

        lti_secret = nil
        begin
          lti_secret = AtomicLti1v1.secret_provider.call(oauth_consumer_key)
        rescue StandardError => e
          Rails.logger.error("Error looking up lti secret, #{e}")
        ensure
          if lti_secret.blank?
            Rails.logger.warn("No lti secret found for oauth_consumer_key: #{oauth_consumer_key}")
          end
        end

        if lti_secret.present? && AtomicLti1v1::Lti1v1.valid_lti_request?(request, lti_secret)
          env['atomic.validated.oauth_consumer_key'] = oauth_consumer_key
        elsif lti_secret.present? && !AtomicLti1v1::Lti1v1.valid_lti_request?(request, lti_secret)
          raise AtomicLti1v1::LtiValidationFailed, "Validation failed for oauth_consumer_key: #{oauth_consumer_key}"
        end

        # Let the frontend know there's no state to validate.  This is an LTI 1.3 thing.
        env["atomic.validated.state_validation"] = {
          state_verified: true,
        }
      end

      @app.call(env)
    end
  end
end
