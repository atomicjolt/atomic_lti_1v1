require_relative 'lti_1v1'
module AtomicLti1v1
  class Lti1v1Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      begin # For now catch all errors, after we are fully commited this wont be necessary

      request = Rack::Request.new(env)
      if AtomicLti1v1::Lti1v1.is_lti_1v1?(request)
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
      end

      rescue StandardError => e # For now catch all errors
        Rails.logger.warn("Error in LTI 1v1 Middleware: #{e}")
      ensure
        @app.call(env)
      end

      #@app.call(env)
    end
  end
end
