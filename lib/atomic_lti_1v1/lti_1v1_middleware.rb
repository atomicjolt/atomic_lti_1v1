require_relative 'lti_1v1'
module AtomicLti1v1
  class Lti1v1Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      request = Rack::Request.new(env)

      if AtomicLti1v1::Lti1v1.is_lti_1v1?(request)
        # TODO: parameterize app instancwe

        oauth_consumer_key = request.params['oauth_consumer_key']
        app_instance = ApplicationInstance.find_by(lti_key: oauth_consumer_key)

        if app_instance.present? && AtomicLti1v1::Lti1v1.valid_lti_request?(request, app_instance.lti_secret)
          env['atomic.validated.oauth_consumer_key'] = oauth_consumer_key
        end
        # TODO: what if no app instance?
      end

      @app.call(env)
    end
  end
end
